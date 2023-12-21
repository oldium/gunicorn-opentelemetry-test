# Gunicorn configuration
import multiprocessing
import os

bind = os.getenv("WEB_BIND", "0.0.0.0:8080")
workers = int(os.getenv("WEB_CONCURRENCY", multiprocessing.cpu_count() * 2 + 1))
worker_class = "uvicorn.workers.UvicornWorker"

# Configure log level (used by OpenTelemetry)
log_level = os.getenv("OTEL_PYTHON_LOG_LEVEL", None)
if log_level:
    import logging
    logging.getLogger().setLevel(level=log_level.upper())
