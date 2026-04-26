# Penantia AI — n8n Automation

Self-hosted n8n on HuggingFace Space.
Live: https://penantiaglobal-penantia-n8n.hf.space
Login: penantiaglobal@gmail.com / Penantia2026!

## Workflows
- **Self-Heal 15min** — detects errors, creates draft PRs on GitHub
- **Autonomous Test 2min** — agent self-directs stress tests, writes to agent_insights
- **Daily Summary 8am AEST** — health report via Telegram

## Architecture
- Database: SQLite persisted to /data (survives restarts)
- Notifications: Telegram
- Backend: https://penantiaglobal-ai-backend.hf.space
- Supabase: jqdmwjglxnuplbokcuvw

## Deploy
Push to main branch → GitHub Actions → auto-deploys to HF Space → Telegram notification
