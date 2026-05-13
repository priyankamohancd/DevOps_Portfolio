# ============================================================
# Multi-stage Dockerfile - great teaching example
# Stage 1 (builder): installs deps; never shipped to production
# Stage 2 (runtime): minimal, secure final image
# ============================================================

# ---------- Stage 1: Builder ----------
FROM python:3.12-slim AS builder

WORKDIR /build

# Copy only requirements first to leverage Docker layer caching.
# If requirements.txt doesn't change, this layer is reused.
COPY app/requirements.txt .

# Install Python deps into a local directory we can copy later.
RUN pip install --no-cache-dir --user -r requirements.txt


# ---------- Stage 2: Runtime ----------
FROM python:3.12-slim AS runtime

# Create non-root user (security best practice).
RUN useradd --create-home --shell /bin/bash appuser

WORKDIR /app

# Copy installed deps from the builder stage.
COPY --from=builder /root/.local /home/appuser/.local

# Copy the application code.
COPY app/ .

# Make sure scripts in .local are usable.
ENV PATH=/home/appuser/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1
ENV APP_VERSION=1.0.0

# Drop privileges.
RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 5000

# Healthcheck for orchestrators (Docker, Compose, Kubernetes).
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1

# Production-grade WSGI server, not Flask's dev server.
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:app"]
