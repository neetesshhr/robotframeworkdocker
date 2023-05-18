FROM python:3.9-slim-buster

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    python3-dev \
    gnupg \
    gnupg1 \
    gnupg2 \
    wget \
    curl \
    unzip \
    xvfb \
    git

# Install Robot Framework and necessary libraries
RUN pip install --no-cache-dir \
    robotframework \
    robotframework-seleniumlibrary \
    robotframework-requests

# Set up Chrome WebDriver
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update -y \
    && apt-get install -y google-chrome-stable

# Set up ChromeDriver
RUN CHROME_DRIVER_VERSION=$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE) \
    && wget -q -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip \
    && unzip /tmp/chromedriver.zip -d /usr/local/bin \
    && rm /tmp/chromedriver.zip \
    && chmod +x /usr/local/bin/chromedriver

# Set up the working directory
WORKDIR /opt/robotframework

# Copy the test files
COPY ./tests /opt/robotframework/tests

# Set the entrypoint
ENTRYPOINT ["robot"]
CMD ["--outputdir", "results", "--loglevel", "INFO", "tests"]
