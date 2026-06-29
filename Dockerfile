FROM n8nio/runners:1.111.0

COPY extras.txt /app/task-runner-python/extras.txt

RUN set -e; \
    PY_BIN="/opt/runners/task-runner-python/.venv/bin/python"; \
    if [ ! -x "$PY_BIN" ]; then PY_BIN="$(command -v python3)"; fi; \
    "$PY_BIN" -m ensurepip --upgrade; \
    "$PY_BIN" -m pip install --no-cache-dir -r /app/task-runner-python/extras.txt
