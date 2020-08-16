pipeline {
  environment {
    registry = "dockerabctest/registry"
    registryCredential = 'docker'
    dockerImage = ''
  }
  agent any
  tools { nodejs "nodeenv" }
  stages {
    stage('Cloning Git') {
      steps {
        git 'https://github.com/SachinNagg/sachinnagp.git'
      }
    }
    stage('Code Quality Check via SonarQube') {
      steps {
        script {
          def scannerHome = tool 'SonarQube';
          withSonarQubeEnv("SonarQube") {
            bat "${scannerHome}/sonar-scanner.bat -Dsonar.projectKey=nagpsonar -Dsonar.sources=. -Dsonar.host.url=http://localhost:9000 -Dsonar.login=0af71ab66ca601daeaddf444f5e292e8d702c4fe"
          }
        }
      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    stage('Push Image') {
      steps{
        script {
          docker.withRegistry('', registryCredential) {
            dockerImage.push()
          }
        }
      }
    }
    stage('check ls cmd') {
      steps {
        script {
          sh '''
          ContainerID = $(docker ps | grep 7000 | cut - d " " - f 1)
          if [ $ContainerID ]
          then
          docker stop $ContainerID
          docker rm - f $ContainerID
          fi
          '''
        }
      }
    }
    stage('Run docker') {
      sh 'docker run -d --name testnagp -p 7000:8080 registry:${BUILD_NUMBER}'
    }
  }
}
