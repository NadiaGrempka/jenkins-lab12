#FROM jenkins/jenkins:lts
#
#USER root
#RUN apt-get update && \
#    apt-get install -y --no-install-recommends \
#      docker.io \
#      git \
#      curl && \
#    rm -rf /var/lib/apt/lists/* && \
#    usermod -aG docker jenkins
#
#USER jenkins
#EXPOSE 8080
#
#CMD ["sh", "-c", "\
#  dockerd & \
#  sleep 5 & \
#  exec /usr/local/bin/jenkins.sh \
#"]
# Builder

FROM node:18 AS builder
WORKDIR /app
COPY app/package*.json ./
RUN npm ci
COPY app/src ./src
COPY tests ./tests
RUN npm test -- --ci --runInBand
# ----------------------------
FROM node:18-alpine
ENV NODE_ENV=production
WORKDIR /app
COPY app/package*.json ./
RUN npm ci --omit=dev
COPY app/src ./src
EXPOSE 3000
CMD ["node", "src/index.js"]

