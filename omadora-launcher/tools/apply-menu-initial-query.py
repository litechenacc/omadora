#!/usr/bin/env python3
"""Deploy the tracked Omadora menu implementation into the selected shell."""
import argparse
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("--check", action="store_true")
parser.add_argument("menu_qml", type=Path)
args = parser.parse_args()
source = Path(__file__).resolve().parent.parent / "qml" / "Menu.qml"
if not source.is_file():
    raise SystemExit(f"Missing managed menu source: {source}")
text = source.read_text()
markers = ("payload.initialQuery", "function isOpen()", "aiSearchMode", 'itemId: "chatgpt-search"')
missing = [marker for marker in markers if marker not in text]
if missing:
    raise SystemExit("Managed menu is missing features: " + ", ".join(missing))
if not args.menu_qml.parent.is_dir():
    raise SystemExit(f"Missing target menu directory: {args.menu_qml.parent}")
if args.check:
    print("Managed Omadora menu source is valid.")
elif args.menu_qml.exists() and args.menu_qml.read_bytes() == source.read_bytes():
    print("Managed Omadora menu already deployed.")
else:
    args.menu_qml.write_bytes(source.read_bytes())
    print(f"Deployed managed menu to {args.menu_qml}")
