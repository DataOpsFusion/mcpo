FROM python:3.11-slim

LABEL org.opencontainers.image.title="mcpo"
LABEL org.opencontainers.image.description="Docker image for mcpo (Model Context Protocol OpenAPI Proxy)"
LABEL org.opencontainers.image.source="https://github.com/alephpiece/mcpo-docker"
LABEL org.opencontainers.image.licenses="MIT"

# install npx prerequisites
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl nodejs npm git  \
 && pip install opencv-mcp-server \
 && npm install -g mcp-mongo-server \
 && npm install -g @leonardsellem/n8n-mcp-server@latest \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install uvx
RUN curl -LsSf https://astral.sh/uv/install.sh \
    | env UV_INSTALL_DIR="/usr/local/bin" sh

WORKDIR /app

# bring in your config
COPY config.json /app/config.json

# open the new port
EXPOSE 5000

# run uvx mcpo on 0.0.0.0:5000
ENTRYPOINT ["uvx","mcpo","--config","/app/config.json","--host","0.0.0.0","--port","5000"]
