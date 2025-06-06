pipeline {
  agent {
    docker {
      image 'nadiagrempka/custom-jenkins-build-agent:1.0.1'
      args  '-u root -v /var/run/docker.sock:/var/run/docker.sock'
    }
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Parallel Tests & Coverage') {
      parallel {
        stage('Unit Tests') {
          steps {
            dir('app') {
                      sh 'npm install'
                      sh 'npm run test:unit --coverage'
                      junit 'coverage/*.xml'
                      archiveArtifacts artifacts: 'coverage/**', fingerprint: true
                    }
          }
        }
        stage('Integration Tests') {
          steps {
            dir('app') {
              sh 'npm run test:integration'
            }
          }
        }
      }
    }


//     stage('Archive Coverage HTML') {
//       steps {
//         publishHTML(target: [
//           allowMissing: false,
//           alwaysLinkToLastBuild: true,
//           keepAll: true,
//           reportDir: 'app/coverage/lcov-report',
//           reportFiles: 'index.html',
//           reportName: 'Coverage Report'
//         ])
//       }
//     }
//
    stage('Publish Coverage') {
          steps {
            cobertura coberturaReportFile: 'app/coverage/cobertura-coverage.xml'
          }
        }


    stage('Archive Artifacts') {
      steps {
        dir('app') {
          archiveArtifacts artifacts: 'coverage/**', allowEmptyArchive: true
          junit 'junit.xml'
        }
      }
    }


    stage('Build Docker Image') {
      steps {
        script {
          docker.withRegistry('', 'dockerhub-credentials-id') {
            def appImage = docker.build("nadiagrempka/moj-microservice:${env.BUILD_NUMBER}")
            appImage.push()
            appImage.push('latest')
          }
        }
      }
    }
  }
  post {
    always {
      sh "docker rmi nadiagrempka/moj-microservice:${env.BUILD_NUMBER} || true"
      sh "docker rmi nadiagrempka/moj-microservice:latest || true"
      echo "Pipeline zakończony (sukces lub porażka)."
    }
  }
}
