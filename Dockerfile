FROM n8nio/runners:latest

USER root

# Cleaned up line continuations and switched to the 'uv' binary
RUN cp -r /opt/runners/task-runner-python/.venv/lib/python*/site-packages/src /tmp/src_backup \
    && uv pip install --python /opt/runners/task-runner-python/.venv ollama requests \
    && cp -r /tmp/src_backup /opt/runners/task-runner-python/.venv/lib/python*/site-packages/src \
    && rm -rf /tmp/src_backup

USER runner
