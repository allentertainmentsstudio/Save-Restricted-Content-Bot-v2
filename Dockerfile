FROM python:3.10.4-slim-buster

# Set non-interactive mode to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update & upgrade safely, clean cache to reduce image size
RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get install -y --no-install-recommends \
        git \
        curl \
        wget \
        python3-pip \
        bash \
        neofetch \
        ffmpeg \
        software-properties-common && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python packages
RUN pip3 install --upgrade pip wheel setuptools && \
    pip3 install --no-cache-dir -r requirements.txt

# Set working directory
WORKDIR /app
COPY . .

# Expose port
EXPOSE 8000

# Run both Flask and your script
CMD flask run -h 0.0.0.0 -p 8000 & python3 -m devgagan
