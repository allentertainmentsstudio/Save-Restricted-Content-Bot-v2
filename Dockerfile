# Dockerfile
FROM python:3.10.4-slim-buster

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install essential packages safely
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release \
        software-properties-common && \
    # Add buster-backports for ffmpeg
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
    # Clean cache
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first to leverage caching
COPY requirements.txt .

# Upgrade pip, wheel, setuptools and install dependencies
RUN pip3 install --upgrade pip wheel setuptools && \
    pip3 install --no-cache-dir -r requirements.txt

# Copy all files
COPY . .

# Expose port for Flask
EXPOSE 8000

# Environment variables for bot (optional, can also use .env)
ENV API_ID=28820919 \
    API_HASH=eb471196bf8c84f34bcc6d607a130b7e \
    BOT_TOKEN=8757539710:AAH9tbGMP_R7reO1iSn_1QqRRzkxDeX8C7Y \
    OWNER_ID=7892805795 \
    MONGO_DB="mongodb+srv://ytpremium4434360:zxx1VPDzGW96Nxm3@itssmarttoolbot.dhsl4.mongodb.net/?retryWrites=true&w=majority&appName=ItsSmartToolBot" \
    LOG_GROUP=-1003791508617 \
    CHANNEL_ID=-1003515041061 \
    FREEMIUM_LIMIT=10 \
    PREMIUM_LIMIT=500 \
    WEBSITE_URL=upshrink.com \
    AD_API=52b4a2cf4687d81e7d3f8f8e78cb \
    STRING=None

# Run Flask + your bot
CMD flask run -h 0.0.0.0 -p 8000 & python3 -m devgagan
