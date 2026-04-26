FROM n8nio/n8n:latest

USER root
RUN mkdir -p /data && chown -R node:node /data

ENV N8N_BASIC_AUTH_ACTIVE=true
ENV N8N_BASIC_AUTH_USER=admin
ENV N8N_BASIC_AUTH_PASSWORD=penantia2026
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=7860
ENV N8N_PROTOCOL=https
ENV WEBHOOK_URL=https://penantiaglobal-penantia-n8n.hf.space
ENV DB_TYPE=sqlite
ENV DB_SQLITE_DATABASE=/data/n8n.db

USER node
EXPOSE 7860
