FROM n8nio/n8n:latest

LABEL version="1.0.0"
LABEL description="Penantia AI n8n automation — Self-Heal + Daily Summary"

USER root

# Create data dir and workflow import dir
RUN mkdir -p /data /data/workflows && chown -R node:node /data

# Copy workflow JSONs
COPY workflows/self_heal.json /data/workflows/self_heal.json
COPY workflows/daily_summary.json /data/workflows/daily_summary.json

# Startup script — imports workflows on every boot then starts n8n
COPY start.sh /start.sh
RUN chmod +x /start.sh

USER node

ENV N8N_BASIC_AUTH_ACTIVE=false
ENV N8N_USER_MANAGEMENT_DISABLED=true
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=7860
ENV N8N_PROTOCOL=https
ENV WEBHOOK_URL=https://penantiaglobal-penantia-n8n.hf.space
ENV DB_TYPE=sqlite
ENV DB_SQLITE_DATABASE=/data/n8n.db
ENV N8N_SKIP_WEBHOOK_DEREGISTRATION_SHUTDOWN=true
ENV EXECUTIONS_PROCESS=main
ENV N8N_DEFAULT_LOCALE=en

EXPOSE 7860

CMD ["/start.sh"]
