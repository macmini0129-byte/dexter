#!/bin/bash
# Daily Research Workflow — triggered by Claude Code cron
# Runs deep research on configured topics, saves to ~/daily/

set -euo pipefail

DATE=$(date +%Y-%m-%d)
TOPICS=("AI agents latest developments" "market trends finance")

for topic in "${TOPICS[@]}"; do
	echo "[$(date +%H:%M)] Researching: $topic"

	# Use Hermes for the research via deep-research skill
	curl -s "http://localhost:8642/v1/chat/completions" \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer $HERMES_API_KEY" \
		-d '{
			"model": "deepseek-chat",
			"messages": [
				{"role": "system", "content": "You are a research assistant. Provide a concise summary with key findings and sources."},
				{"role": "user", "content": "Research: '"$topic"'. Focus on latest developments in the past week."}
			],
			"max_tokens": 2048
		}' 2>/dev/null | python3 -c "
import json,sys
try:
    d = json.load(sys.stdin)
    print(d['choices'][0]['message']['content'])
except:
    print('Research failed')
" >> "$HOME/daily/$DATE-research.md" 2>&1

	echo "" >> "$HOME/daily/$DATE-research.md"
done

echo "Research saved to ~/daily/$DATE-research.md"
