# Use the official Jenkins base image
FROM jenkins/jenkins:lts

# Switch to the root user to install additional packages
USER root

# Install Node.js and Google Chrome
RUN apt-get update && \
    apt-get install -y \
        curl \
        wget \
        gnupg \
        # Install required libraries for Headless Chrome
        fonts-liberation \
        libappindicator3-1 \
        libasound2 \
        libatk-bridge2.0-0 \
        libatk1.0-0 \
        libcups2 \
        libdbus-1-3 \
        libgconf-2-4 \
        libx11-xcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxi6 \
        libxrandr2 \
        libxss1 \
        libxtst6 \
        libnss3 \
        libgbm-dev \
    # Install Node.js
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    # Add Google's public key and Chrome repository
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list \
    # Install Google Chrome
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    # Clean up to reduce image size
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Puppeteer
RUN npm install -g puppeteer

# Set CHROME_BIN environment variable
ENV CHROME_BIN=/usr/bin/google-chrome

# Switch back to the Jenkins user
USER jenkins

# Expose ports
EXPOSE 8080 4200

# Default command to run Jenkins
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
