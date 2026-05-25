FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app
ENV PORT=8080
EXPOSE 8080
# Use gunicorn for production readiness; keep simple here for portfolio
CMD ["gunicorn", "--bind", "0.0.0.0:$(PORT)", "app:create_app()", "--workers", "1"]
