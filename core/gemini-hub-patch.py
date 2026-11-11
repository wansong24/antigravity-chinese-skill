#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Google Gemini.app (macOS) 内嵌 Antigravity (Contents/Helpers/agy --hub) 汉化补丁引擎
保持 Mach-O 二进制与内嵌 ZIP 字节长度 100% 严格对齐，原子替换，不破坏正在运行的宿主进程与 Gemini 主程序签名。
"""

import os
import sys
import json
import struct
import shutil
import zipfile
import io
import subprocess

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DICT_PATH = os.path.join(PROJECT_ROOT, "dict", "zh-CN.json")
RUNTIME_PATH = os.path.join(PROJECT_ROOT, "core", "i18n-runtime.js")
BACKUP_DIR = os.path.expanduser("~/.gemini/antigravity-chinese-backup")

MARKER_START = b"// --- AGY-I18N-HUB-START ---"
MARKER_END = b"// --- AGY-I18N-HUB-END ---"

BLOATED_SVGS = {
    "symbols-icons/icons/files/rslib.svg",
    "symbols-icons/icons/files/hugo.svg",
    "symbols-icons/icons/files/rspack.svg",
    "symbols-icons/icons/files/rsbuild.svg",
    "symbols-icons/icons/files/expressive-code.svg",
    "symbols-icons/icons/folders/folder-firebase.svg",
    "symbols-icons/icons/files/firebase.svg",
}
SIMPLE_SVG = b'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><rect width="20" height="20" x="2" y="2" rx="4" fill="#64748b"/></svg>'


def get_candidate_gemini_apps():
    homedir = os.path.expanduser("~")
    candidates = [
        "/Applications/Gemini.app",
        os.path.join(homedir, "Applications", "Gemini.app"),
        os.path.join(homedir, "Desktop", "Gemini.app"),
    ]
    found = []
    for app in candidates:
        agy_bin = os.path.join(app, "Contents", "Helpers", "agy")
        if os.path.isfile(agy_bin):
            found.append(app)
    return found


def locate_embedded_zip(data: bytes):
    p = data.find(b"prism_bundle.js")
    if p == -1:
        return None
    eocd = data.find(b"PK\x05\x06", p)
    if eocd == -1:
        return None
    cd_size, cd_offset, comment_len = struct.unpack_from("<IIH", data, eocd + 12)
    zip_start = (eocd - cd_size) - cd_offset
    zip_end = eocd + 22 + comment_len
    if zip_start < 0 or zip_end > len(data) or zip_start >= zip_end:
        return None
    return zip_start, zip_end


def check_status():
    apps = get_candidate_gemini_apps()
    if not apps:
        return {"installed": False, "apps": []}
    results = []
    for app in apps:
        agy_bin = os.path.join(app, "Contents", "Helpers", "agy")
        patched = False
        try:
            with open(agy_bin, "rb") as f:
                data = f.read()
            loc = locate_embedded_zip(data)
            if loc:
                zf = zipfile.ZipFile(io.BytesIO(data[loc[0]:loc[1]]), "r")
                patched = MARKER_START in zf.read("prism_bundle.js")
        except Exception:
            pass
        results.append({"app": app, "patched": patched})
    return {"installed": True, "apps": results}


def install_patch():
    apps = get_candidate_gemini_apps()
    if not apps:
        return 0

    os.makedirs(BACKUP_DIR, exist_ok=True)
    with open(DICT_PATH, "r", encoding="utf-8") as f:
        d = json.load(f)
    dict_str = json.dumps(d, ensure_ascii=False, separators=(",", ":"))
    with open(RUNTIME_PATH, "r", encoding="utf-8") as f:
        runtime_str = f.read()

    bundle_js = (
        b"\n" + MARKER_START + b"\n;(function() {\n  try {\n    window.__AGY_I18N_DATA__ = "
        + dict_str.encode("utf-8")
        + b";\n"
        + runtime_str.encode("utf-8")
        + b'\n    if (window.__AGY_RUN_FULL_SCAN__) window.__AGY_RUN_FULL_SCAN__();\n  } catch(e) {\n    console.error("[AGY-i18n] Runtime Injection Error:", e);\n  }\n})();\n'
        + MARKER_END + b"\n"
    )

    count = 0
    for app_path in apps:
        agy_path = os.path.join(app_path, "Contents", "Helpers", "agy")
        try:
            with open(agy_path, "rb") as f:
                data = bytearray(f.read())
            loc = locate_embedded_zip(data)
            if not loc:
                continue
            zip_start, zip_end = loc
            target_len = zip_end - zip_start

            orig_zf = zipfile.ZipFile(io.BytesIO(data[zip_start:zip_end]), "r")
            prism_bytes = orig_zf.read("prism_bundle.js")
            bak_path = os.path.join(BACKUP_DIR, "gemini-agy.bak")
            if MARKER_START not in prism_bytes and not os.path.exists(bak_path):
                shutil.copy2(agy_path, bak_path)

            out_buf = io.BytesIO()
            with zipfile.ZipFile(out_buf, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as new_zf:
                for info in orig_zf.infolist():
                    content = orig_zf.read(info.filename)
                    if info.filename == "prism_bundle.js":
                        if MARKER_START in content and MARKER_END in content:
                            s_idx = content.find(MARKER_START)
                            content = content[:s_idx].rstrip()
                        content = content + bundle_js
                    elif info.filename == "index.html":
                        content = content.replace(b'src="/prism_bundle.js"', b'src="/prism_bundle.js?v=zh4"')
                    elif info.filename in BLOATED_SVGS:
                        content = SIMPLE_SVG
                    new_zf.writestr(
                        info,
                        content,
                        compress_type=info.compress_type,
                        compresslevel=9 if info.compress_type == zipfile.ZIP_DEFLATED else None,
                    )

            raw_zip = bytearray(out_buf.getvalue())
            diff = target_len - len(raw_zip)
            if not (0 <= diff <= 65535):
                raise RuntimeError(f"ZIP 对齐差值超出范围: {diff}")
            raw_zip[-2:] = diff.to_bytes(2, "little")
            raw_zip.extend(b" " * diff)
            data[zip_start:zip_end] = raw_zip

            import tempfile
            tmp_path = os.path.join(tempfile.gettempdir(), f"agy_zh_{os.getpid()}")
            with open(tmp_path, "wb") as f:
                f.write(data)
            os.chmod(tmp_path, 0o755)
            subprocess.run(["/usr/bin/codesign", "-f", "-s", "-", "-i", "agy", tmp_path], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            try:
                shutil.copyfile(tmp_path, agy_path)
            finally:
                if os.path.exists(tmp_path):
                    os.remove(tmp_path)
            subprocess.run(["/usr/bin/xattr", "-dr", "com.apple.quarantine", app_path], check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            print(f"✅ 已完成 Gemini 内嵌版 Antigravity 汉化注入: {app_path}")
            count += 1
        except PermissionError:
            if is_patched(agy_path):
                print(f"ℹ️ Gemini 内嵌版已处于汉化状态: {app_path}")
            else:
                print(f"ℹ️ 跳过 {app_path}（需在「系统设置 -> 隐私与安全性 -> App 管理」中授权后可修改第三方 App 包）")
        except Exception as e:
            print(f"⚠️ 修补 {app_path} 失败: {e}", file=sys.stderr)
    return count


def restore_patch():
    apps = get_candidate_gemini_apps()
    bak_path = os.path.join(BACKUP_DIR, "gemini-agy.bak")
    if not apps or not os.path.exists(bak_path):
        return 0
    count = 0
    for app_path in apps:
        agy_path = os.path.join(app_path, "Contents", "Helpers", "agy")
        try:
            tmp_path = agy_path + ".tmp_restore"
            shutil.copy2(bak_path, tmp_path)
            os.chmod(tmp_path, 0o755)
            os.replace(tmp_path, agy_path)
            print(f"✅ 已还原 Gemini 内嵌版 Antigravity 英文原版: {app_path}")
            count += 1
        except Exception as e:
            print(f"⚠️ 还原 {app_path} 失败: {e}", file=sys.stderr)
    return count


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "status"
    if cmd == "install":
        install_patch()
    elif cmd == "restore":
        restore_patch()
    elif cmd == "status":
        print(json.dumps(check_status(), ensure_ascii=False))
