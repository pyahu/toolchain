#!/usr/bin/env python3
"""Validate local Markdown links and the syntax of every public shell example."""

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
DOCUMENTS = sorted(
    [
        *ROOT.glob("*.md"),
        *(ROOT / "docs").glob("*.md"),
        *(ROOT / ".github").glob("*.md"),
    ]
)
LINK = re.compile(r"\[[^]]+\]\(([^)]+)\)")
FENCE = re.compile(r"^```(sh|bash)\s*$")


def shell_blocks(document: Path) -> list[tuple[int, str]]:
    blocks = []
    language = None
    start = 0
    content: list[str] = []
    for number, line in enumerate(document.read_text().splitlines(), 1):
        if language is None:
            if FENCE.match(line):
                language = line[3:]
                start = number + 1
                content = []
        elif line == "```":
            blocks.append((start, "\n".join(content) + "\n"))
            language = None
        else:
            content.append(line)
    if language is not None:
        raise ValueError(f"{document.relative_to(ROOT)}:{start}: unclosed shell fence")
    return blocks


def main() -> int:
    failures = []
    link_count = 0
    block_count = 0
    for document in DOCUMENTS:
        text = document.read_text()
        for target in LINK.findall(text):
            if (
                "://" in target
                or target.startswith("#")
                or target.startswith("mailto:")
            ):
                continue
            link_count += 1
            relative = target.split("#", 1)[0]
            if relative and not (document.parent / relative).resolve().exists():
                failures.append(
                    f"{document.relative_to(ROOT)}: missing link target {target}"
                )

        try:
            blocks = shell_blocks(document)
        except ValueError as error:
            failures.append(str(error))
            continue
        for line, block in blocks:
            block_count += 1
            result = subprocess.run(
                ["sh", "-n"], input=block, text=True, capture_output=True, check=False
            )
            if result.returncode:
                detail = result.stderr.strip() or "invalid shell syntax"
                failures.append(f"{document.relative_to(ROOT)}:{line}: {detail}")

    if failures:
        print("documentation validation failed:", file=sys.stderr)
        print("\n".join(f"- {failure}" for failure in failures), file=sys.stderr)
        return 1
    print(
        f"documentation passed: {len(DOCUMENTS)} files, "
        f"{link_count} local links, {block_count} shell examples"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
