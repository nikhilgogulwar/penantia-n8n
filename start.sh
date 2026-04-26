#!/bin/sh
set -e

echo "=== Penantia n8n v1.0.0 startup ==="
echo "DB: $N8N_SQLITE_DATABASE"

# Start n8n in background to initialise DB + create tables
n8n start &
N8N_PID=$!

echo "Waiting for n8n to initialise (30s)..."
sleep 30

# Check if owner account already exists
OWNER_EXISTS=$(n8n user:list 2>/dev/null | grep -c "penantiaglobal@gmail.com" || echo "0")

if [ "$OWNER_EXISTS" = "0" ]; then
  echo "Creating owner account..."
  n8n user:create \
    --email="penantiaglobal@gmail.com" \
    --firstName="Penantia" \
    --lastName="AI" \
    --password="Penantia2026!" \
    --role="global:owner" 2>/dev/null || echo "Owner creation via CLI not supported — will use setup API"

  # Fallback: use REST API to complete setup
  sleep 5
  curl -s -X POST http://localhost:7860/rest/owner/setup \
    -H "Content-Type: application/json" \
    -d '{"email":"penantiaglobal@gmail.com","firstName":"Penantia","lastName":"AI","password":"Penantia2026!"}' \
    > /tmp/setup_result.json 2>&1
  echo "Setup result: $(cat /tmp/setup_result.json)"
fi

echo "Importing workflows..."

# Login to get session cookie
curl -s -c /tmp/cookies.txt -X POST http://localhost:7860/rest/login \
  -H "Content-Type: application/json" \
  -d '{"emailOrLdapLoginId":"penantiaglobal@gmail.com","password":"Penantia2026!"}' \
  > /tmp/login_result.json 2>&1
echo "Login: $(cat /tmp/login_result.json | head -c 100)"

# Check existing workflows
EXISTING=$(curl -s -b /tmp/cookies.txt http://localhost:7860/rest/workflows | python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d.get('data',d if isinstance(d,list) else [])))" 2>/dev/null || echo "0")
echo "Existing workflows: $EXISTING"

if [ "$EXISTING" = "0" ]; then
  echo "No workflows found — importing..."

  # Import Self-Heal workflow
  curl -s -b /tmp/cookies.txt -X POST http://localhost:7860/rest/workflows \
    -H "Content-Type: application/json" \
    -d @/data/workflows/self_heal.json \
    > /tmp/wf1.json 2>&1
  WF1_ID=$(python3 -c "import json; d=json.load(open('/tmp/wf1.json')); print(d.get('data',{}).get('id','?'))" 2>/dev/null || echo "?")
  echo "Self-Heal created: $WF1_ID"

  # Import Daily Summary workflow
  curl -s -b /tmp/cookies.txt -X POST http://localhost:7860/rest/workflows \
    -H "Content-Type: application/json" \
    -d @/data/workflows/daily_summary.json \
    > /tmp/wf2.json 2>&1
  WF2_ID=$(python3 -c "import json; d=json.load(open('/tmp/wf2.json')); print(d.get('data',{}).get('id','?'))" 2>/dev/null || echo "?")
  echo "Daily Summary created: $WF2_ID"

  # Activate both
  if [ "$WF1_ID" != "?" ]; then
    VER1=$(python3 -c "import json; d=json.load(open('/tmp/wf1.json')); print(d.get('data',{}).get('versionId',''))" 2>/dev/null || echo "")
    curl -s -b /tmp/cookies.txt -X POST http://localhost:7860/rest/workflows/$WF1_ID/activate \
      -H "Content-Type: application/json" -d "{"versionId":"$VER1"}" > /dev/null
    echo "Self-Heal activated"
  fi

  if [ "$WF2_ID" != "?" ]; then
    VER2=$(python3 -c "import json; d=json.load(open('/tmp/wf2.json')); print(d.get('data',{}).get('versionId',''))" 2>/dev/null || echo "")
    curl -s -b /tmp/cookies.txt -X POST http://localhost:7860/rest/workflows/$WF2_ID/activate \
      -H "Content-Type: application/json" -d "{"versionId":"$VER2"}" > /dev/null
    echo "Daily Summary activated"
  fi
else
  echo "Workflows already present — skipping import"
fi

echo "=== n8n ready ==="

# Wait for main n8n process
wait $N8N_PID
