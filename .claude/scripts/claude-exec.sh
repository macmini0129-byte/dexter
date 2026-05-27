#!/bin/bash
# Claude Exec — execute a task in Claude Code from Hermes/scripts
# Usage: ./claude-exec.sh "task description" [project-dir]

set -euo pipefail

TASK="${1:-}"
DIR="${2:-$HOME/dexter}"

if [ -z "$TASK" ]; then
	echo "Usage: claude-exec.sh <task> [project-dir]"
	exit 1
fi

cd "$DIR"

# Run Claude Code non-interactively with -p/--print
claude -p "$TASK" 2>/dev/null || {
	# Fallback: run via nohup
	nohup claude -p "$TASK" > "/tmp/claude-exec-$(date +%s).log" 2>&1 &
	echo $! > /tmp/claude-exec.pid
	echo "Claude task started (PID: $(cat /tmp/claude-exec.pid))"
}
