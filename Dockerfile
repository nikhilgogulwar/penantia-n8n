FROM n8nio/n8n:latest

LABEL version="1.0.1"
LABEL maintainer="penantiaglobal@gmail.com"
LABEL description="Penantia AI n8n — Self-Heal + Daily Summary automations"

USER root

RUN mkdir -p /data/workflows && chown -R node:node /data

COPY --chown=node:node workflows/ /data/workflows/
COPY --chown=node:node start.sh /home/node/start.sh
RUN chmod +x /home/node/start.sh

USER node

ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=7860
ENV N8N_PROTOCOL=https
ENV WEBHOOK_URL=https://penantiaglobal-penantia-n8n.hf.space
ENV DB_TYPE=sqlite
ENV DB_SQLITE_DATABASE=/data/n8n.db
ENV N8N_USER_MANAGEMENT_DISABLED=false
ENV EXECUTIONS_PROCESS=main
ENV N8N_SKIP_WEBHOOK_DEREGISTRATION_SHUTDOWN=true

EXPOSE 7860

CMD ["sh", "/home/node/start.sh"]
