#!/bin/bash
# 列文菜单 — Claude Code 自定义命令和工作流速查

clear
cat << 'MENU'
╔══════════════════════════════════════════════════════════╗
║                    列文菜单 · 工作流速查                   ║
╚══════════════════════════════════════════════════════════╝

▓ 联动桥接
────────────────────────────────────────────────────────────
  hermes "问题"           Claude → Hermes 调技能查资料
  claude "任务"            Hermes → Claude 改代码/跑脚本
  inbox                   查看 ~/.claude/inbox/ 待办任务

▓ 浏览器自动化
────────────────────────────────────────────────────────────
  browser <url> text       获取页面文字内容
  browser <url> screenshot  截取全页截图
  browser <url> click .btn  点击页面元素
  browser <url> fill #id x  填写输入框

▓ DevOps 巡检
────────────────────────────────────────────────────────────
  devops                   系统状态 + Git + API 健康检查
  gh issue list            查看 GitHub Issues
  gh pr list               查看 Pull Requests

▓ 每日科研
────────────────────────────────────────────────────────────
  research                 跑 Hermes 研究 → ~/daily/
  daily                    写 / 追加今日笔记

▓ Git 工作流 (pre-commit hook 自动跑)
────────────────────────────────────────────────────────────
  git add <file>           自动触发 Biome 检查 + 修复
  git commit               格式/lint 检查通过后才提交

▓ 项目内快速操作
────────────────────────────────────────────────────────────
  test                     跑 bun test
  typecheck                跑 tsc --noEmit
  start                    启动 Dexter TUI
  dev                      bun --watch 开发模式

MENU

echo "提示: 以上命令在 Claude Code 中直接用自然语言说就行"
echo "      比如 "用 Hermes 查一下今天 AI 新闻""
