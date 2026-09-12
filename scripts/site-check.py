#!/usr/bin/env python3
"""Check generated site routes, assets, and same-origin fragments."""

from __future__ import annotations

import sys
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urljoin, urlsplit


ROOT = Path(__file__).resolve().parent.parent
DIST = ROOT / "website" / "dist"
SITE_ORIGIN = "https://toolchain.terson.workers.dev"


class DocumentParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.ids: set[str] = set()
        self.targets: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        values = dict(attrs)
        if identifier := values.get("id"):
            self.ids.add(identifier)
        for attribute in ("href", "src"):
            if target := values.get(attribute):
                self.targets.append(target)


def output_path(url_path: str) -> Path:
    if url_path.rstrip("/") == "/404":
        return DIST / "404.html"
    path = DIST / unquote(url_path).lstrip("/")
    if url_path.endswith("/"):
        return path / "index.html"
    if path.is_file():
        return path
    return path / "index.html"


def main() -> int:
    failures: list[str] = []
    documents: dict[Path, DocumentParser] = {}
    for document in sorted(DIST.rglob("*.html")):
        parser = DocumentParser()
        parser.feed(document.read_text())
        documents[document.resolve()] = parser

    for document, parser in documents.items():
        route = "/" + document.relative_to(DIST).as_posix()
        if route.endswith("/index.html"):
            route = route.removesuffix("index.html")
        page_url = urljoin(SITE_ORIGIN, route)

        for target in parser.targets:
            if target.startswith(("#", "data:", "mailto:", "javascript:")):
                continue
            resolved = urlsplit(urljoin(page_url, target))
            if resolved.netloc != urlsplit(SITE_ORIGIN).netloc:
                continue
            if resolved.path.endswith(".md"):
                failures.append(f"{route}: source Markdown link leaked: {target}")
                continue

            destination = output_path(resolved.path).resolve()
            if (
                not destination.is_relative_to(DIST.resolve())
                or not destination.exists()
            ):
                failures.append(f"{route}: missing target {target}")
                continue
            if resolved.fragment and destination.suffix == ".html":
                destination_parser = documents.get(destination)
                if (
                    destination_parser
                    and unquote(resolved.fragment) not in destination_parser.ids
                ):
                    failures.append(f"{route}: missing fragment {target}")

    required = [
        DIST / "index.html",
        DIST / "404.html",
        DIST / "getting-started" / "index.html",
        DIST / "catalog" / "index.html",
        DIST / "pagefind" / "pagefind.js",
        DIST / "sitemap-index.xml",
    ]
    failures.extend(
        f"missing required output {path.relative_to(ROOT)}"
        for path in required
        if not path.exists()
    )

    if failures:
        print("site validation failed:", file=sys.stderr)
        print("\n".join(f"- {failure}" for failure in failures), file=sys.stderr)
        return 1
    print(f"site passed: {len(documents)} HTML pages and all local targets resolve")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
