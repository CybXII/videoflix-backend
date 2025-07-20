FROM python:3.12-slim

# Optional, aber empfohlen
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

# Nur requirements.txt zuerst – Docker Cache-Optimierung
COPY requirements.txt .

RUN apk update && \
    apk add --no-cache --upgrade bash && \
    apk add --no-cache postgresql-client ffmpeg && \
    apk add --no-cache --virtual .build-deps \
        gcc \
        musl-dev \
        postgresql-dev \
        libffi-dev \
        openssl-dev \
        cargo \
        python3-dev && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    apk del .build-deps

# Jetzt restliches Projekt rein
COPY . .

# Script ausführbar machen
RUN chmod +x backend.entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["./backend.entrypoint.sh"]
