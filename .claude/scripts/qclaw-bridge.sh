#!/bin/bash
# Qclaw Bridge — send messages through Qclaw channels
# Usage: ./qclaw-bridge.sh <channel> <message>
#   Channels: telegram, feishu, wechat, qqbot, teams

set -euo pipefail

CHANNEL="${1:-}"
MESSAGE="${2:-}"
QCLAW_TOKEN="${QCLAW_TOKEN:-660594952c4022bfe0b6ed6e5e199980dde908b79f543519}"
QCLAW_URL="${QCLAW_URL:-http://127.0.0.1:28789}"

if [ -z "$CHANNEL" ] || [ -z "$MESSAGE" ]; then
	echo "Usage: qclaw-bridge.sh <channel> <message>"
	echo ""
	echo "Available channels:"
	echo "  telegram   — Telegram bot"
	echo "  feishu     — Feishu/Lark bot"
	echo "  wechat     — WeChat Access"
	echo "  qqbot      — QQ Bot"
	echo "  teams      — Microsoft Teams"
	echo ""
	echo "Examples:"
	echo '  qclaw-bridge.sh telegram "Hello from Claude Code"'
	echo '  qclaw-bridge.sh feishu "Research report ready"'
	exit 1
fi

# Build message payload
PAYLOAD=$(cat <<EOF
{
	"channel": "$CHANNEL",
	"message": {
		"type": "text",
		"text": "$MESSAGE"
	}
}
EOF
)

# Send via Qclaw gateway protocol (OpenAI-compatible endpoint)
RESPONSE=$(curl -s -X POST "$QCLAW_URL/v1/chat/completions" \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer $QCLAW_TOKEN" \
	-d "$PAYLOAD" 2>&1)

if echo "$RESPONSE" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('object',''))" 2>/dev/null | grep -q "chat"; then
	echo "Message sent to $CHANNEL"
else
	echo "Qclaw response: $RESPONSE"
fi
