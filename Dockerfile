FROM python:3.12-slim

# Set environment variables to prevent Python from writing pyc files and to avoid buffering in logs
ENV PYTHONUNBUFFERED=1 \
    UV_COMPILE_BYTECODE=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PYTHONDONTWRITEBYTECODE=1

RUN pip install uv

# Add a non-privileged user for running the application
RUN groupadd --gid 10001 app && \
    useradd -g app --uid 10001 --shell /usr/sbin/nologin --create-home --home-dir /app app

ADD . /app
WORKDIR /app
RUN uv sync --locked --no-progress

# Command to run your application
USER app
CMD ["uv", "run", "script.py"]
