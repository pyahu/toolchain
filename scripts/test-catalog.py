#!/usr/bin/env python3
"""Prove that a pin-only update stays consistent and reaches the built catalog."""

from pathlib import Path
import shutil
import subprocess
import sys
import tempfile


ROOT = Path(__file__).resolve().parent.parent


def main() -> None:
    with tempfile.TemporaryDirectory(prefix="toolchain-catalog-test-") as directory:
        fixture = Path(directory)
        for name in ["docs", "scripts"]:
            shutil.copytree(ROOT / name, fixture / name)
        for source in [
            ROOT / "README.md",
            ROOT / "catalog.toml",
            *ROOT.glob("mise*.toml"),
        ]:
            shutil.copy2(source, fixture / source.name)
        config = fixture / "mise.toml"
        lines = config.read_text().splitlines()
        config.write_text(
            "\n".join(
                'ripgrep = "99.0.0"' if line.startswith("ripgrep =") else line
                for line in lines
            )
            + "\n"
        )
        subprocess.run(
            [sys.executable, "scripts/catalog.py", "--check"], cwd=fixture, check=True
        )
        subprocess.run(
            [sys.executable, "scripts/stage-site-docs.py"], cwd=fixture, check=True
        )
        page = (fixture / "website/src/content/docs/docs/catalog.md").read_text()
        assert any(
            line.startswith("| ripgrep |") and line.endswith("| 99.0.0 |")
            for line in page.splitlines()
        ), "New pin missing from website"
    print("catalog pin-update regression passed")


if __name__ == "__main__":
    main()
