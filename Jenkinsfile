pipeline {
  agent {
    docker {
      image '<TwojDockerHub>/custom-jenkins-agent-node:1.0.0'
      args  '-u root -v /var/run/docker.sock:/var/run/docker.sock'
    }
  }

  environment {
    APP_NAME    = 'microservice-app'
    DOCKER_REG  = 'docker.io'
    HUB_CRED_ID = 'dockerhub-credentials'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install & Lint') {
      steps {
        sh 'npm ci'
        sh 'npm run lint'
      }
    }

    stage('Parallel Tests & Coverage') {
      parallel {
        stage('Unit Tests') {
          steps {
            sh 'npm run test:unit'
          }
        }
        stage('Integration Tests') {
          steps {
            sh 'npm run test:integration'
          }
        }
      }
    }

    stage('Archive Artifacts') {
      steps {
        junit 'junit.xml'
        archiveArtifacts artifacts: 'coverage/**', fingerprint: true
        // Jeżeli masz plugin Cobertura:
        publishCoverage adapters: [coberturaAdapter('coverage/cobertura-coverage.xml')]
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          def tag   = "${env.BUILD_NUMBER}"
          def image = "${DOCKER_REG}/${env.APP_NAME}:${tag}"
          sh "docker build -t ${image} ."
          sh "docker tag ${image} ${DOCKER_REG}/${env.APP_NAME}:latest"
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: "${HUB_CRED_ID}",
          usernameVariable: 'USER',
          passwordVariable: 'PASS'
        )]) {
          sh 'echo "$PASS" | docker login -u "$USER" --password-stdin ${DOCKER_REG}'
          sh "docker push ${DOCKER_REG}/${env.APP_NAME}:${env.BUILD_NUMBER}"
          sh "docker push ${DOCKER_REG}/${env.APP_NAME}:latest"
          sh 'docker logout'
        }
      }
    }
  }

  post {
    always {
      sh 'docker image prune -f'
      echo 'Czyszczenie zasobów wykonane'
    }
    success {
      echo 'Pipeline zakończony powodzeniem!'
    }
    failure {
      echo 'Ups! Coś poszło nie tak...'
    }
  }
}
