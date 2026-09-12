#!/usr/bin/env python3
"""Render and verify the public tool catalog from catalog.toml and mise configs."""

from __future__ import annotations

import argparse
import difflib
import sys
from pathlib import Path

import tomllib

ROOT = Path(__file__).resolve().parent.parent
CATALOG = ROOT / "catalog.toml"
README = ROOT / "README.md"
PROFILES = ROOT / "docs" / "profiles.md"
CATALOG_DOC = ROOT / "docs" / "catalog.md"
LAUNCH = ROOT / "docs" / "launch.md"
HERO = ROOT / "docs" / "assets" / "hero.svg"


def replace_block(text: str, name: str, body: str) -> str:
    start = f"<!-- {name}:start -->"
    end = f"<!-- {name}:end -->"
    if text.count(start) != 1 or text.count(end) != 1:
        raise ValueError(f"expected exactly one {start!r} and {end!r}")
    before, remainder = text.split(start, 1)
    _, after = remainder.split(end, 1)
    return f"{before}{start}\n{body.rstrip()}\n{end}{after}"


def load_catalog() -> list[dict]:
    data = tomllib.loads(CATALOG.read_text())
    if data.get("schema") != 1:
        raise ValueError("catalog.toml has an unsupported schema")
    profiles = data.get("profiles", [])
    ids = [profile["id"] for profile in profiles]
    if len(ids) != len(set(ids)):
        raise ValueError("profile IDs must be unique")
    known = set(ids)

    for profile in profiles:
        configured = tomllib.loads((ROOT / profile["file"]).read_text()).get(
            "tools", {}
        )
        metadata = {tool["key"]: tool for tool in profile.get("tools", [])}
        if len(metadata) != len(profile.get("tools", [])):
            raise ValueError(f"{profile['id']}: tool keys must be unique")
        missing = configured.keys() - metadata.keys()
        extra = metadata.keys() - configured.keys()
        if missing or extra:
            raise ValueError(
                f"{profile['id']}: metadata/config mismatch; "
                f"missing={sorted(missing)}, extra={sorted(extra)}"
            )
        for tool in profile["tools"]:
            tool["version"] = configured[tool["key"]]
            required = {"name", "purpose", "rationale"}
            absent = required - tool.keys()
            if absent:
                raise ValueError(
                    f"{profile['id']}/{tool['key']}: missing {sorted(absent)}"
                )
        if profile["rolling"] != all(
            tool["version"] == "latest" for tool in profile["tools"]
        ):
            raise ValueError(
                f"{profile['id']}: rolling status does not match configured versions"
            )
        unknown = set(profile.get("recommended_profiles", [])) - known
        if unknown:
            raise ValueError(
                f"{profile['id']}: unknown profile dependencies {sorted(unknown)}"
            )
    return profiles


def render_catalog(profiles: list[dict]) -> str:
    lines = []
    for profile in profiles:
        selector = (
            "always active"
            if profile["id"] == "base"
            else f"`MISE_ENV={profile['id']}`"
        )
        channel = ", rolling" if profile["rolling"] else ""
        lines.extend(
            [
                f"**{profile['title']}** (`{profile['file']}`, {selector}{channel})",
                "",
                "| Tool | Purpose | Version |",
                "| ---- | ------- | ------- |",
            ]
        )
        for tool in profile["tools"]:
            lines.append(f"| {tool['name']} | {tool['purpose']} | {tool['version']} |")
        lines.append("")
    return "\n".join(lines)


def render_summary(profiles: list[dict]) -> str:
    tool_count = sum(len(profile["tools"]) for profile in profiles)
    return f"**Current catalog:** {tool_count} tools across {len(profiles)} profiles."


def validate_public_facts(profiles: list[dict]) -> None:
    tool_count = sum(len(profile["tools"]) for profile in profiles)
    profile_count = len(profiles)
    expected = {
        LAUNCH: [f"{tool_count} developer CLI tools", f"{profile_count} profiles"],
        HERO: [f">{tool_count} tools<", f">{profile_count} profiles<"],
    }
    for document, facts in expected.items():
        content = document.read_text()
        missing = [fact for fact in facts if fact not in content]
        if missing:
            raise ValueError(
                f"{document.relative_to(ROOT)} has stale public facts: {missing}"
            )


def render_profile_map(profiles: list[dict]) -> str:
    lines = [
        "| Profile | Intended user | Adds | Suggested profiles | Prerequisites |",
        "| ------- | ------------- | ---- | ------------------ | ------------- |",
    ]
    for profile in profiles:
        label = "Base" if profile["id"] == "base" else f"`{profile['id']}`"
        dependencies = (
            ", ".join(
                f"`{dependency}`"
                for dependency in profile.get("recommended_profiles", [])
            )
            or "—"
        )
        lines.append(
            f"| {label} | {profile['audience']} | {profile['adds']} | {dependencies} | "
            f"{profile['prerequisites']} |"
        )
    return "\n".join(lines)


def expected_files(profiles: list[dict]) -> dict[Path, str]:
    validate_public_facts(profiles)
    readme = replace_block(
        README.read_text(), "catalog-summary", render_summary(profiles)
    )
    catalog = replace_block(
        CATALOG_DOC.read_text(), "catalog", render_catalog(profiles)
    )
    guide = replace_block(
        PROFILES.read_text(), "profile-map", render_profile_map(profiles)
    )
    return {README: readme, CATALOG_DOC: catalog, PROFILES: guide}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--check", action="store_true", help="fail if generated docs are stale"
    )
    args = parser.parse_args()
    try:
        expected = expected_files(load_catalog())
    except (KeyError, OSError, tomllib.TOMLDecodeError, ValueError) as error:
        print(f"catalog error: {error}", file=sys.stderr)
        return 1

    stale = False
    for path, content in expected.items():
        current = path.read_text()
        if current == content:
            continue
        if args.check:
            stale = True
            diff = difflib.unified_diff(
                current.splitlines(),
                content.splitlines(),
                fromfile=str(path),
                tofile=f"{path} (generated)",
            )
            print("\n".join(diff), file=sys.stderr)
        else:
            path.write_text(content)
            print(f"updated {path.relative_to(ROOT)}")
    if stale:
        print("catalog docs are stale; run ./scripts/catalog.py", file=sys.stderr)
        return 1
    if args.check:
        print("catalog metadata and generated docs are current")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
