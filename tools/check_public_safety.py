#!/usr/bin/env python3
from __future__ import annotations

import ipaddress
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

FORBIDDEN_NAMES = {
    ".env",
    "wp-config.php",
    "credentials.json",
    "secrets.json",
    "id_rsa",
    "id_ed25519",
}

PRIVATE_KEY_MARKERS = (
    "-----BEGIN " + "OPENSSH PRIVATE KEY-----",
    "-----BEGIN " + "RSA PRIVATE KEY-----",
    "-----BEGIN " + "EC PRIVATE KEY-----",
    "-----BEGIN " + "PRIVATE KEY-----",
)

SECRET_ASSIGNMENT = re.compile(
    r"""(?ix)
    \b(password|passwd|api[_-]?key|access[_-]?token|auth[_-]?token|
       client[_-]?secret|secret[_-]?key)\b
    \s*[:=]\s*
    ["']?([^\s"'#]{8,})
    """
)

IP_ASSIGNMENT = re.compile(
    r"""(?ix)
    \b(server[_-]?ip|host[_-]?ip|public[_-]?ip)\b
    \s*[:=]\s*
    ["']?(\d{1,3}(?:\.\d{1,3}){3})
    """
)

SAFE_VALUE_PARTS = (
    "${",
    "<",
    ">",
    "example",
    "dummy",
    "changeme",
    "replace-me",
    "your_",
    "your-",
    "xxxxxxxx",
)

def tracked_files():
    result = subprocess.run(
        ["git", "-C", str(ROOT), "ls-files", "-z"],
        check=True,
        stdout=subprocess.PIPE,
    ).stdout
    return [ROOT / p.decode("utf-8") for p in result.split(b"\0") if p]

def is_public_ip(value):
    try:
        address = ipaddress.ip_address(value)
    except ValueError:
        return False
    return bool(address.is_global)

def main():
    problems = []

    for path in tracked_files():
        relative = path.relative_to(ROOT)
        name = path.name

        if name in FORBIDDEN_NAMES and not name.endswith(".example"):
            problems.append(f"{relative}: forbidden sensitive filename")

        if name.startswith(".env") and not name.endswith(".example"):
            problems.append(f"{relative}: environment file must not be committed")

        if path.suffix.lower() in {".pem", ".key"}:
            problems.append(f"{relative}: private key/certificate file is not allowed")

        try:
            text = path.read_text(encoding="utf-8")
        except (UnicodeDecodeError, OSError):
            continue

        for marker in PRIVATE_KEY_MARKERS:
            if marker in text:
                problems.append(f"{relative}: private key marker found")

        for match in SECRET_ASSIGNMENT.finditer(text):
            value = match.group(2).strip().lower()
            if any(part in value for part in SAFE_VALUE_PARTS):
                continue
            if value in {"true", "false", "publish", "draft", "private"}:
                continue
            problems.append(
                f"{relative}: possible hard-coded secret near '{match.group(1)}'"
            )

        for match in IP_ASSIGNMENT.finditer(text):
            if is_public_ip(match.group(2)):
                problems.append(
                    f"{relative}: public IP appears to be hard-coded in a setting"
                )

    if problems:
        print("Public safety check FAILED:")
        for problem in sorted(set(problems)):
            print(f" - {problem}")
        return 1

    print("Public safety check OK: no obvious credentials or production IP settings found.")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
