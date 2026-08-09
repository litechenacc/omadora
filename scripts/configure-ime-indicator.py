#!/usr/bin/env python3
"""Add Omadora's Fcitx5 indicator to an Omarchy shell.json bar layout."""
import argparse
import json
from pathlib import Path

INDICATOR = {
    "id": "omadora.ime",
    "type": "command",
    "exec": "omadora-ime-status",
    "interval": 1,
    "onClick": "fcitx5-remote -t",
    "tooltip": "Input method",
}

parser = argparse.ArgumentParser()
parser.add_argument("--check", action="store_true")
parser.add_argument("--dry-run", action="store_true")
parser.add_argument("path", type=Path)
args = parser.parse_args()

try:
    config = json.loads(args.path.read_text())
except (OSError, json.JSONDecodeError) as error:
    raise SystemExit(f"Cannot read valid shell configuration {args.path}: {error}")

try:
    right = config["bar"]["layout"]["right"]
except (KeyError, TypeError) as error:
    raise SystemExit(f"shell configuration has no bar.layout.right array: {error}")
if not isinstance(right, list):
    raise SystemExit("shell configuration bar.layout.right is not an array")

matches = [index for index, item in enumerate(right) if isinstance(item, dict) and item.get("id") == INDICATOR["id"]]
if len(matches) > 1:
    raise SystemExit("shell configuration contains duplicate omadora.ime modules")
if matches:
    right[matches[0]] = INDICATOR
    action = "updated"
else:
    right.insert(0, INDICATOR)
    action = "added"

if args.check:
    print("IME indicator shell configuration is valid.")
elif args.dry_run:
    print(f"Would {action} {INDICATOR['id']} in {args.path}")
else:
    temporary = args.path.with_name(f".{args.path.name}.ime-indicator.tmp")
    temporary.write_text(json.dumps(config, ensure_ascii=False, indent=2) + "\n")
    temporary.replace(args.path)
    print(f"{action.capitalize()} {INDICATOR['id']} in {args.path}")
