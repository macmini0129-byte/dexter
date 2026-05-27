#!/bin/bash
# DevOps Health Check — triggered by Claude Code cron
# Checks service health, git status, and disk usage

set -euo pipefail

echo "=== DevOps Health Check: $(date '+%Y-%m-%d %H:%M') ==="

# Git status
cd "$HOME/dexter"
echo "[Git] Branch: $(git branch --show-current)"
echo "[Git] Ahead/behind: $(git rev-list --count --left-right HEAD...@{upstream} 2>/dev/null || echo 'no upstream')"
echo "[Git] Uncommitted: $(git status --short | wc -l) files"

# Disk usage
echo "[Disk] $(df -h / | awk 'NR==2 {print $3 \" used / \" $2 \" (\" $5 \")\"}')"

# Hermes API health
if curl -sf http://localhost:8642/health > /dev/null 2>&1; then
	echo "[Hermes] API: OK"
else
	echo "[Hermes] API: DOWN"
fi

# Memory
echo "[Memory] $(vm_stat | awk '/active/ {print $NF}' | head -1) pages active"

echo "=== Done ==="
