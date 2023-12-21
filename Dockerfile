FROM python:3.12-slim-bookworm

ARG PIP_DISABLE_PIP_VERSION_CHECK=1
ARG PIP_NO_CACHE_DIR=1
ARG PIP_ROOT_USER_ACTION=ignore

WORKDIR /app

# Simulate K8S OpenTelemetry operator
COPY requirements-opentelemetry.txt .
RUN mkdir /opentelemetry && pip install --target /opentelemetry -r requirements-opentelemetry.txt

# Now install the app
COPY requirements.txt .
RUN pip install --upgrade -r requirements.txt

COPY . .

# Simulate env variables from K8s OpenTelemetry operator
ENV PYTHONPATH=/opentelemetry/opentelemetry/instrumentation/auto_instrumentation:/opentelemetry
ENV OTEL_SERVICE_NAME="my-service"
ENV OTEL_TRACES_EXPORTER="console"
ENV OTEL_METRICS_EXPORTER="console"
ENV OTEL_LOGS_EXPORTER="console"

# Custom config (log level set in gunicorn.conf.py actually, OTEL_PYTHON_LOG_CORRELATION looks incompatible with
# OTEL_PYTHON_LOGGING_AUTO_INSTRUMENTATION_ENABLED)
ENV OTEL_PYTHON_LOG_LEVEL="info"
ENV OTEL_PYTHON_LOGGING_AUTO_INSTRUMENTATION_ENABLED="true"

ENV WEB_BIND="0.0.0.0:8080"
EXPOSE 8080
CMD ["gunicorn", "app:app"]
