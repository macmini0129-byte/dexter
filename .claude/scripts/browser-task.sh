#!/bin/bash
# Browser Automation — Playwright-based web task execution
# Usage: ./browser-task.sh "url" "action" [selector] [value]

set -euo pipefail

URL="${1:-}"
ACTION="${2:-screenshot}"
SELECTOR="${3:-}"
VALUE="${4:-}"

if [ -z "$URL" ]; then
	echo "Usage: browser-task.sh <url> <action> [selector] [value]"
	echo "Actions: screenshot, click, fill, text, html, pdf"
	exit 1
fi

cd "$HOME/dexter"

bun run .claude/scripts/browser-task.ts "$URL" "$ACTION" "$SELECTOR" "$VALUE"
