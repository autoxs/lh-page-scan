# Use below url to get chrome and chromedriver latest version
# https://googlechromelabs.github.io/chrome-for-testing/
#============================================
# User below command to build docker image
#=============================================
# docker build --build-arg CHROME_VERSION=129.0.6668.70 --build-arg CHROME_DRIVER_VERSION=129.0.6668.70 -t nxt-selenium-chrome .
#=============================================
# Use below command to run docker image
#=============================================
# docker run -d --name <alias name> nxt-selenium-chrome
#=============================================
# Use below comman to get into docker container
#=============================================
# docker run -it selenium-webdriverjs /bin/bash
#=============================================
# Uese below lines to use / pull image
# docker.io/aytesh/nxt-selenium-chrome
# docker pull aytesh/nxt-selenium-chrome

# Use the official Node.js image
FROM node:20

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    unzip \
    libnss3 \
    libgconf-2-4 \
    libxi6 \
    libxss1 \
    libasound2 \
    libxrandr2 \
    libgtk-3-0 \
    libdrm2 \
    libgbm-dev \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Arguments for Chrome and ChromeDriver versions
ARG CHROME_VERSION
ARG CHROME_DRIVER_VERSION

# Download and install Google Chrome from the specified URL
RUN wget -O /tmp/chrome-linux64.zip "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chrome-linux64.zip" || { echo "Failed to download Chrome"; exit 1; } \
    && echo "Downloaded Chrome successfully." \
    && mkdir -p /tmp/chrome-temp || { echo "Failed to create temp directory"; exit 1; } \
    && unzip /tmp/chrome-linux64.zip -d /tmp/chrome-temp || { echo "Failed to unzip Chrome"; exit 1; } \
    && echo "Unzipped Chrome successfully." \
    && ls -la /tmp/chrome-temp/ || { echo "No files found in /tmp/chrome-temp"; exit 1; } \
    && mv /tmp/chrome-temp/chrome-linux64/* /usr/local/bin/ || { echo "Failed to move Chrome files"; exit 1; } \
    && echo "Moved Chrome files successfully." \
    && rm -rf /tmp/chrome-temp

# Download and install ChromeDriver from the specified URL
RUN wget -O /tmp/chromedriver-linux64.zip "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_DRIVER_VERSION}/linux64/chromedriver-linux64.zip" || { echo "Failed to download ChromeDriver"; exit 1; } \
    && echo "Downloaded ChromeDriver successfully." \
    && mkdir -p /tmp/chromedriver-temp || { echo "Failed to create temp directory"; exit 1; } \
    && unzip /tmp/chromedriver-linux64.zip -d /tmp/chromedriver-temp/ || { echo "Failed to unzip ChromeDriver"; exit 1; } \
    && echo "Unzipped ChromeDriver successfully." \
    && mv /tmp/chromedriver-temp/chromedriver-linux64/* /usr/local/bin/ || { echo "Failed to move Chrome files"; exit 1; } \
    && ls -la /usr/local/bin/ || { echo "No files found in /usr/local/bin/chromedriver-linux64/"; exit 1; } \
    && rm /tmp/chromedriver-linux64.zip \
    && chmod +x /usr/local/bin/chromedriver || { echo "Failed to make ChromeDriver executable"; exit 1; }

# Set the working directory inside the container
WORKDIR /app

# COPY package.json ./
# RUN npm install

# COPY . .
