FROM python:3.10.4-slim-buster

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Update package lists & install essentials safely
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release \
        software-properties-common && \
    # Add backports for ffmpeg
    echo "deb http://deb.debian.org/debian buster-backports main" > /etc/apt/sources.list.d/backports.list && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
        git \
        curl \
        wget \
        python3-pip \
        bash \
        neofetch \
        ffmpeg && \
    # Clean cache to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy Python requirements first for caching
COPY requirements.txt .

# Upgrade pip & install Python packages
RUN pip3 install --upgrade pip wheel setuptools && \
    pip3 install --no-cache-dir -r requirements.txt

# Set working directory
WORKDIR /app
COPY . .

# Expose port
EXPOSE 8000

# Run Flask and your script
CMD flask run -h 0.0.0.0 -p 8000 & python3 -m devgagan
