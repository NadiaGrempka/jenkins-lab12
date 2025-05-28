FROM jenkins/jenkins:lts

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      docker.io \
      git \
      curl && \
    rm -rf /var/lib/apt/lists/* && \
    usermod -aG docker jenkins

USER jenkins
EXPOSE 8080

CMD ["sh", "-c", "\
  dockerd & \
  sleep 5 & \
  exec /usr/local/bin/jenkins.sh \
"]
