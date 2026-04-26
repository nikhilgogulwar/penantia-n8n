---
title: Penantia n8n
emoji: ⚙️
colorFrom: orange
colorTo: red
sdk: docker
pinned: false
app_port: 7860
---

# Penantia AI — n8n Automation

Self-hosted n8n on HuggingFace Space.
Live: https://penantiaglobal-penantia-n8n.hf.space
Login: penantiaglobal@gmail.com / Penantia2026!

## Workflows
- **Self-Heal 15min** — detects errors, creates draft PRs on GitHub
- **Daily Summary 8am AEST** — health report via Telegram

## Architecture
- Database: SQLite at /data/n8n.db
- Notifications: Telegram (@PenantiaAlertsBot → 148289049)
- Backend: https://penantiaglobal-ai-backend.hf.space
- Supabase: jqdmwjglxnuplbokcuvw

## Deploy
Push to main → GitHub Actions → HF Space rebuilds → Telegram notification
