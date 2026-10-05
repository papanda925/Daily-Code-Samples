from pathlib import Path
from tempfile import TemporaryDirectory

def main() -> int:
    # 実ファイルを壊さないよう、一時ディレクトリだけを使います。
    with TemporaryDirectory(prefix="papanda-pathlib-") as temp_dir:
        base = Path(temp_dir)
        data_dir = base / "data"
        data_dir.mkdir()

        report = data_dir / "report.csv"
        report.write_text("name,value\nA,1\n", encoding="utf-8")

        print(f"path={report}")
        print(f"name={report.name}")
        print(f"suffix={report.suffix}")
        print(f"parent={report.parent.name}")
        print(f"exists={report.exists()}")
        print(f"resolved={report.resolve()}")

        expected = (
            report.name == "report.csv"
            and report.suffix == ".csv"
            and report.parent.name == "data"
            and report.exists()
            and report.resolve().is_absolute()
        )

        if not expected:
            print("[FAILED] unexpected pathlib result")
            return 1

        print("[SUCCESS] pathlib Path operations completed")
        return 0

if __name__ == "__main__":
    raise SystemExit(main())
