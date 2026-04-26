#!/bin/sh
set -e

echo "=== Penantia n8n startup ==="

# Start n8n in background briefly to initialise DB
n8n start &
N8N_PID=$!

# Wait for n8n to be ready
echo "Waiting for n8n to initialise..."
sleep 20

# Import workflows (idempotent — n8n skips if already exists)
echo "Importing workflows..."
n8n import:workflow --input=/data/workflows/self_heal.json || echo "self_heal import failed"
n8n import:workflow --input=/data/workflows/daily_summary.json || echo "daily_summary import failed"

echo "Workflows imported. n8n running."

# Wait for background n8n process
wait $N8N_PID
