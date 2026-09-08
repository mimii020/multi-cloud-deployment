FROM python:3.12-slim

WORKDIR /app

RUN groupadd \
    --system appgroup \
    && useradd \
    --system \
    --gid appgroup \
    appuser

COPY requirements.txt .

RUN pip install \
    --no-cache-dir \
    -r requirements.txt

COPY app ./app

RUN chown \
    -R appuser:appgroup \
    /app

USER appuser

EXPOSE 8080

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]