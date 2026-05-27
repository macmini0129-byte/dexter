#!/bin/bash
# Hermes Bridge — call Hermes agent from Claude Code
# Usage: ./hermes-bridge.sh "prompt" [model]

set -euo pipefail

PROMPT="${1:-}"
MODEL="${2:-deepseek-chat}"
HERMES_URL="${HERMES_API_URL:-http://localhost:8642}"
HERMES_KEY="${HERMES_API_KEY:-}"

if [ -z "$PROMPT" ]; then
	echo "Usage: hermes-bridge.sh <prompt> [model]"
	exit 1
fi

curl -s "$HERMES_URL/v1/chat/completions" \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer $HERMES_KEY" \
	-d "$(cat <<EOF
{
	"model": "$MODEL",
	"messages": [{"role": "user", "content": "$PROMPT"}],
	"max_tokens": 4096
}
EOF
)" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['choices'][0]['message']['content'])" 2>/dev/null || echo "Hermes call failed (is it running?)"
