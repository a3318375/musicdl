FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    HOST=0.0.0.0 \
    PORT=5000

WORKDIR /app

RUN sed -i 's|http://deb.debian.org/debian|https://mirrors.tuna.tsinghua.edu.cn/debian|g; s|http://security.debian.org/debian-security|https://mirrors.tuna.tsinghua.edu.cn/debian-security|g' /etc/apt/sources.list.d/debian.sources

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        ffmpeg \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt requirements-optional.txt setup.py README.md MANIFEST.in ./
COPY musicdl ./musicdl
RUN pip install --upgrade pip \
    && pip install -e .

COPY examples/claudeai-modern-web-music-player/requirements.txt /tmp/web-requirements.txt
RUN pip install -r /tmp/web-requirements.txt

COPY examples/claudeai-modern-web-music-player ./examples/claudeai-modern-web-music-player

WORKDIR /app/examples/claudeai-modern-web-music-player
RUN mkdir -p downloads config musicdl_outputs

EXPOSE 5000

CMD ["python", "app.py"]
