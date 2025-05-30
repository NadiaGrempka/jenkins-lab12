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
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run lint

# Runtime
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/src ./src
EXPOSE 3000
CMD ["npm", "start"]
