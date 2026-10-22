# Python version supported by this project's lockfile.
FROM python:3.12-slim-bookworm
COPY --from=ghcr.io/astral-sh/uv:0.13.5 /uv /uvx /usr/local/bin/

RUN apt-get update && apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*

# Keep the environment outside /app so a source bind mount cannot hide it.
ENV UV_PROJECT_ENVIRONMENT=/opt/venv \
    UV_LOCKED=true \
    UV_NO_DEV=true \
    PATH="/usr/local/bin:/opt/venv/bin:${PATH}"
WORKDIR /app

# Install only versions in the committed lock, then install the project.
COPY pyproject.toml uv.lock ./
RUN uv sync --locked --no-dev --no-install-project
COPY . .
RUN uv sync --locked --no-dev

ENTRYPOINT ["crewai"]
CMD ["run"]

# Pass API keys at runtime with --env-file; do not bake them into the image.
