FROM jenkins/inbound-agent:latest

USER root

# 2. Zainstaluj Node.js (w wersji 18 LTS jako przykład), npm, git, curl, jq i klienta Docker
#    Możesz dostosować wersję Node do wersji, której używasz w projekcie mikroserwisowym.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      gnupg \
      lsb-release \
      git \
      jq && \
    \
    # Dodaj repozytorium NodeSource dla Node.js 18.x
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    \
    # Zainstaluj klienta Docker (tylko client, bez dockerd)
    apt-get install -y docker.io && \
    \
    # Wyczyść cache apt
    rm -rf /var/lib/apt/lists/*

# 3. Dodaj użytkownika jenkins do grupy docker, aby mógł korzystać z hostowego socketa
RUN usermod -aG docker jenkins

# 4. (Opcjonalnie) Zainstaluj narzędzia testujące globalnie
#    Jeśli w projekcie Node.js używasz np. Jest i NYC do coverage:
RUN npm install -g jest nyc

# 5. Przełącz ponownie na użytkownika jenkins
USER jenkins

# 6. (Opcjonalnie) Ustaw katalog roboczy – w zależności od tego, jak Jenkins agenta użyje
WORKDIR /home/jenkins

# 7. Nie musimy nic uruchamiać w CMD, bo Jenkins inbound-agent
#    automatycznie podłącza się do mastera.
#    Jeśli chcesz przekazać dodatkowe argumenty, użyj ENTRYPOINT lub CMD według dokumentacji.
