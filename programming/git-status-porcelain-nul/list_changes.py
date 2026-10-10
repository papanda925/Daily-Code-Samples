#!/usr/bin/env python3
"""git status --porcelain=v1 -z をNUL区切りで安全に読む例。

対象: Python 3.8+ / Git 2.x。Git管理下のディレクトリで実行する。
ファイルの追加・削除・コミットは行わず、Gitの状態を読み取るだけ。
"""
import os
import subprocess


def parse_porcelain_v1_z(data: bytes):
    """(XY, 現在のパス, rename/copy前のパスまたはNone) の配列を返す。"""
    if not data:
        return []
    if not data.endswith(b"\0"):
        raise ValueError("NUL終端ではない不完全なGit status出力です")

    fields = data[:-1].split(b"\0")
    result = []
    i = 0
    while i < len(fields):
        record = fields[i]
        i += 1
        if len(record) < 4 or record[2:3] != b" ":
            raise ValueError(f"想定外のporcelain v1レコード: {record!r}")

        xy = record[:2].decode("ascii")
        current_path = os.fsdecode(record[3:])
        original_path = None

        # -zのrename/copyは「変更後のパス NUL 元のパス NUL」。
        if "R" in xy or "C" in xy:
            if i >= len(fields):
                raise ValueError("rename/copyの元パスがありません")
            original_path = os.fsdecode(fields[i])
            i += 1

        result.append((xy, current_path, original_path))
    return result


def main():
    completed = subprocess.run(
        ["git", "status", "--porcelain=v1", "-z", "--untracked-files=all"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=True,
    )
    entries = parse_porcelain_v1_z(completed.stdout)
    print(f"検出件数: {len(entries)}")
    for xy, current, original in entries:
        if original is None:
            print(f"{xy} {current!r}")
        else:
            print(f"{xy} {original!r} -> {current!r}")


if __name__ == "__main__":
    main()
