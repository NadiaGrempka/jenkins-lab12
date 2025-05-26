# jenkins-agent/Dockerfile
FROM jenkins/inbound-agent:latest

USER root

# 1) Zainstaluj docker-cli (docker.io)
RUN apt-get update && apt-get install -y --no-install-recommends \
      docker.io \
    && rm -rf /var/lib/apt/lists/*

# 2) Node.js i narzędzia dev
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
 && apt-get update && apt-get install -y nodejs git jq \
 && npm install -g eslint jest supertest jest-junit \
 && rm -rf /var/lib/apt/lists/*

# 3) Dodaj jenkins do grupy docker, żeby miał dostęp do socketu
RUN usermod -aG docker jenkins

USER jenkins
