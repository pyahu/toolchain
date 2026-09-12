#!/usr/bin/env python3
"""Stage the repository documentation for Astro Starlight."""

from __future__ import annotations

import json
import re
import shutil
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "docs"
CONTENT_ROOT = ROOT / "website" / "src" / "content" / "docs"
CONTENT = CONTENT_ROOT / "docs"
SOURCE_ASSETS = SOURCE / "assets"
PUBLIC_ASSETS = ROOT / "website" / "public" / "assets"
ASTRO_ASSETS = ROOT / "website" / "src" / "assets"
TITLE = re.compile(r"^# (.+)\n+")
LOCAL_DOC_LINK = re.compile(r"]\(([a-z0-9-]+)\.md(#[^)]+)?\)")


def rewrite_local_link(match: re.Match[str]) -> str:
    page = match.group(1)
    fragment = match.group(2) or ""
    route = "/docs/" if page == "index" else f"/docs/{page}/"
    return f"]({route}{fragment})"


def stage_document(source: Path) -> None:
    text = source.read_text()
    match = TITLE.match(text)
    if match is None:
        raise ValueError(f"{source.relative_to(ROOT)} must start with one H1")

    title = match.group(1)
    body = text[match.end() :]
    body = LOCAL_DOC_LINK.sub(rewrite_local_link, body)
    if source.name == "index.md":
        body = body.replace(
            "![Pyahu Toolchain — a practical mise setup for everyday CLI tools]"
            "(assets/hero.svg){ .toolchain-hero }",
            '<img class="toolchain-hero" src="/assets/hero.svg" '
            'alt="Pyahu Toolchain — a practical mise setup for everyday CLI tools">',
        )
        body = body.replace(
            "[Get started](getting-started.md){ .md-button .md-button--primary }\n"
            "[Browse profiles](profiles.md){ .md-button }",
            '<div class="toolchain-actions">\n'
            '  <a href="/docs/getting-started/">Get started</a>\n'
            '  <a href="/docs/profiles/">Browse profiles</a>\n'
            "</div>",
        )

    draft = "draft: true\n" if source.name == "404.md" else ""
    edit_url = "https://github.com/pyahu/toolchain/edit/main/docs/" + source.name
    frontmatter = (
        f"---\ntitle: {json.dumps(title)}\n"
        f"editUrl: {json.dumps(edit_url)}\n{draft}---\n\n"
    )
    target = (
        CONTENT_ROOT / source.name if source.name == "404.md" else CONTENT / source.name
    )
    target.write_text(frontmatter + body)


def main() -> int:
    shutil.rmtree(CONTENT_ROOT, ignore_errors=True)
    shutil.rmtree(PUBLIC_ASSETS, ignore_errors=True)
    shutil.rmtree(ASTRO_ASSETS, ignore_errors=True)
    CONTENT.mkdir(parents=True)
    ASTRO_ASSETS.mkdir(parents=True)

    for source in sorted(SOURCE.glob("*.md")):
        stage_document(source)

    shutil.copytree(SOURCE_ASSETS, PUBLIC_ASSETS)
    shutil.copy2(SOURCE_ASSETS / "mark.svg", ASTRO_ASSETS / "mark.svg")
    print(
        f"staged {len(list(CONTENT_ROOT.rglob('*.md')))} documentation pages under /docs"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
