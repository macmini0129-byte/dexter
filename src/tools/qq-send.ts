/**
 * qq_send tool — send a message via OpenClaw Gateway QQ Bot channel.
 *
 * Calls the openclaw CLI to dispatch a message through the running gateway.
 * Requires the OpenClaw gateway to be running on localhost:18789.
 */
import { execSync } from "node:child_process";
import { DynamicStructuredTool } from "@langchain/core/tools";
import { z } from "zod";
import { formatToolResult } from "./types.js";

const OPENCLAW_DIR = "/Users/qclaw/openclaw";
const DEFAULT_TARGET = "qqbot:c2c:6BA2D2765B8196785C4DB40DB25CD59D";

/**
 * Rich description for the qq_send tool.
 */
export const QQ_SEND_DESCRIPTION = `
Send a message via QQ Bot through the OpenClaw Gateway.

## When to Use

- When you need to send a message to the user via QQ
- For delivering reports, alerts, or notifications
- When the user asks you to send something to their QQ

## When NOT to Use

- For general web search or data lookup (use web_search or web_fetch instead)
- For financial data queries (use get_financials, get_market_data instead)

## Usage Notes

- Messages are sent as plain text (markdown is supported)
- The target defaults to the primary user (金总)
- Specify target for other recipients using the "qqbot:c2c:<openid>" format
`.trim();

export const qqSendTool = new DynamicStructuredTool({
	name: "qq_send",
	description:
		"Send a message via QQ Bot through the OpenClaw Gateway. Use for delivering reports, alerts, or notifications to the user on QQ.",
	schema: z.object({
		message: z
			.string()
			.describe("The message text to send. Supports markdown."),
		target: z
			.string()
			.optional()
			.describe(
				'Recipient in "qqbot:c2c:<openid>" format. Defaults to the primary user.',
			),
	}),
	func: async (input) => {
		const target = input.target ?? DEFAULT_TARGET;

		try {
			const result = execSync(
				`pnpm openclaw message send --channel qqbot --target "${target}" --message ${JSON.stringify(input.message)}`,
				{
					cwd: OPENCLAW_DIR,
					timeout: 180_000,
					maxBuffer: 1024 * 1024,
				},
			);
			const output = result.toString().trim();
			const lines = output
				.split("\n")
				.filter((l) => l.includes("✅ Sent") || l.includes("Message ID"));
			const summary =
				lines.length > 0
					? lines.join("; ")
					: "Message sent (no confirmation line found)";
			return formatToolResult(
				{ success: true, summary, raw: output.slice(0, 500) },
				[],
			);
		} catch (err) {
			const errorMessage = err instanceof Error ? err.message : String(err);
			return formatToolResult({ success: false, error: errorMessage }, []);
		}
	},
});
