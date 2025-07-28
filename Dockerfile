# ---------- Stage 1: Build Environment ----------
FROM python:3.11-slim as builder

WORKDIR /app

# Copy only requirement files first to leverage Docker cache
COPY requirements.txt .

# Upgrade pip and install dependencies in a virtual environment
RUN apt-get update && apt-get install -y build-essential \
    && python -m venv /venv \
    && /venv/bin/pip install --upgrade pip \
    && /venv/bin/pip install -r requirements.txt \
    && apt-get purge -y build-essential \
    && apt-get autoremove -y \
    && rm -rf /root/.cache

# ---------- Stage 2: Runtime Environment ----------
FROM python:3.11-slim as runtime

WORKDIR /app

# Copy the virtual environment from builder stage
COPY --from=builder /venv /venv

# Activate virtualenv by default
ENV PATH="/venv/bin:$PATH"

# Copy the Django app source code
COPY . /app/

# Expose Django default port
EXPOSE 8000

# Run migrations and start server
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]
