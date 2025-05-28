pipeline {
  agent {
    docker {
      image 'nadiagrempka/jenkins:2.0'
      args '-u root -v /var/run/docker.sock:/var/run/docker.sock --privileged'
    }
  }
  options {
    skipDefaultCheckout()
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '10'))
  }
//test
  stages {
    stage('Checkout') {
      agent {
        docker {
          image 'nadiagrempka/jenkins:2.0'
          args '-u root -v /var/run/docker.sock:/var/run/docker.sock --privileged'
        }
      }
      steps {
        git url: 'https://github.com/NadiaGrempka/jenkins-lab12.git', branch: 'main'
        sh 'mvn validate'
      }
    }

    stage('Test & Coverage') {
      steps {
        // testy jednostkowe + coverage w jednym etapie
        sh 'mvn test'
        junit '**/target/surefire-reports/*.xml'
        // po zainstalowaniu pluginu Pipeline: JaCoCo:
        //jacoco execPattern: '**/target/jacoco.exec'
      }
    }

    stage('Archive Artifacts') {
      steps {
        archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
        archiveArtifacts artifacts: '**/target/site/jacoco/**/*', allowEmptyArchive: true
      }
    }

    stage('Build & Push Docker Image') {
      environment {
        APP_NAME              = 'jenkins'
        DOCKER_REPOSITORY     = "nadiagrempka/${APP_NAME}"
        DOCKER_CREDENTIALS_ID = 'sha256:a3d73c5b43d47a4aa8ab563d001f89b6f1d557883b0dbac216140c1fc699adca'
        DOCKER_REGISTRY       = 'docker.io'
      }
      steps {
        script {
          def tagNum    = "${DOCKER_REPOSITORY}:${env.BUILD_NUMBER}"
          def tagLatest = "${DOCKER_REPOSITORY}:2.0"
          docker.build(tagNum, "-f Dockerfile .")
          docker.build(tagLatest, "-f Dockerfile .")
        }
        withCredentials([usernamePassword(
          credentialsId: DOCKER_CREDENTIALS_ID,
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh "echo \$DOCKER_PASS | docker login ${DOCKER_REGISTRY} -u \$DOCKER_USER --password-stdin"
          sh "docker push ${DOCKER_REPOSITORY}:${env.BUILD_NUMBER}"
          sh "docker push ${DOCKER_REPOSITORY}:2.0"
        }
      }
    }

    stage('Cleanup') {
      agent any
      steps {
        sh '''
          docker rmi nadiagrempka/jenkins:${BUILD_NUMBER} || true
          docker rmi nadiagrempka/jenkins:2.0   || true
          docker system prune -f                         || true
        '''
      }
    }
  }

  post {
    success { echo '✅ Pipeline zakończony sukcesem' }
    failure { echo '❌ Pipeline zakończony niepowodzeniem' }
  }
}