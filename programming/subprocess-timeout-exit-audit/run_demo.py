#!/usr/bin/env python3
"""Observe child-process success, failure, and timeout using harmless Python commands."""
import argparse
import subprocess
import sys
from dataclasses import dataclass
from typing import Optional, Sequence


@dataclass(frozen=True)
class Outcome:
    status: str
    returncode: Optional[int]
    stdout: str
    stderr: str


def decode_partial(value: object) -> str:
    """TimeoutExpired may carry bytes even when text=True was requested."""
    if value is None:
        return ""
    if isinstance(value, bytes):
        return value.decode("utf-8", errors="replace")
    return str(value)


def run_checked(command: Sequence[str], timeout_seconds: float) -> Outcome:
    """Run an explicit argument list, never a shell command string."""
    if not command or timeout_seconds <= 0:
        raise ValueError("command must be nonempty and timeout must be positive")
    try:
        result = subprocess.run(
            list(command),
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            timeout=timeout_seconds,
            check=False,
            shell=False,
        )
    except subprocess.TimeoutExpired as exc:
        return Outcome("TIMEOUT", None, decode_partial(exc.stdout), decode_partial(exc.stderr))
    except OSError as exc:
        # Do not include environment paths or the full command in output.
        return Outcome("START_FAILED", None, "", type(exc).__name__)
    return Outcome("OK" if result.returncode == 0 else "NONZERO", result.returncode,
                   result.stdout, result.stderr)


def demo_command(mode: str) -> list[str]:
    # sys.executable selects the current Python interpreter, not a PATH guess.
    if mode == "ok":
        script = "print('child: done')"
    elif mode == "fail":
        script = "import sys; print('child: failed', file=sys.stderr); sys.exit(7)"
    elif mode == "timeout":
        script = "import time; print('child: waiting', flush=True); time.sleep(30)"
    else:
        raise ValueError("unknown mode")
    return [sys.executable, "-c", script]


def main(argv: Optional[Sequence[str]] = None) -> int:
    parser = argparse.ArgumentParser(description="Observe subprocess exit status and timeout safely")
    parser.add_argument("--mode", choices=("ok", "fail", "timeout"), default="ok")
    parser.add_argument("--timeout", type=float, default=10.0, help="positive timeout in seconds")
    args = parser.parse_args(argv)
    if not 0 < args.timeout < float("inf"):
        parser.error("--timeout must be a finite positive number")
    outcome = run_checked(demo_command(args.mode), args.timeout)
    print("STATUS=" + outcome.status)
    print("CHILD_RETURN_CODE=" + (str(outcome.returncode) if outcome.returncode is not None else "N/A"))
    print("STDOUT=" + outcome.stdout.strip())
    print("STDERR=" + outcome.stderr.strip())
    return {"OK": 0, "NONZERO": 1, "TIMEOUT": 124, "START_FAILED": 127}[outcome.status]


if __name__ == "__main__":
    raise SystemExit(main())
