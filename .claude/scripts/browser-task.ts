import { chromium } from "playwright";

const url = process.argv[2];
const action = process.argv[3] || "screenshot";
const selector = process.argv[4] || "";
const value = process.argv[5] || "";

if (!url) {
	console.error(
		"Usage: bun run browser-task.ts <url> <action> [selector] [value]",
	);
	console.error("Actions: screenshot, click, fill, text, html, pdf");
	process.exit(1);
}

async function main() {
	const browser = await chromium.launch({ headless: true });
	const page = await browser.newPage();
	await page.goto(url, { waitUntil: "networkidle", timeout: 30000 });

	switch (action) {
		case "screenshot":
			await page.screenshot({ path: "/tmp/browser-shot.png", fullPage: true });
			console.log("Screenshot saved to /tmp/browser-shot.png");
			break;
		case "text": {
			const text = await page.evaluate(() => document.body.innerText);
			console.log(text?.substring(0, 5000));
			break;
		}
		case "html": {
			const html = await page.content();
			console.log(html?.substring(0, 5000));
			break;
		}
		case "click":
			if (selector) {
				await page.click(selector);
				console.log("Clicked:", selector);
			}
			break;
		case "fill":
			if (selector && value) {
				await page.fill(selector, value);
				console.log("Filled", selector, "with", value);
			}
			break;
		case "pdf":
			await page.pdf({ path: "/tmp/browser-page.pdf", format: "A4" });
			console.log("PDF saved to /tmp/browser-page.pdf");
			break;
	}
	await browser.close();
}

main().catch((e) => {
	console.error("Error:", e.message);
	process.exit(1);
});
