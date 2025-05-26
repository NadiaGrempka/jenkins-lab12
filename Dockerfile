# plik: jenkins-agent/Dockerfile
FROM jenkins/inbound-agent:latest

USER root

# Node.js + narzędzia
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg git jq docker.io \
  && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g eslint jest supertest jest-junit \
  && rm -rf /var/lib/apt/lists/*

# Dodaj jenkinsa do grupy docker
RUN usermod -aG docker jenkins

USER jenkins
