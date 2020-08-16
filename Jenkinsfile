pipeline {
  environment {
    registry = "dockerabctest/registry"
    registryCredential = 'docker'
    dockerImage = ''
  }
  agent any
  tools {nodejs "node"}
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
           withSonarQubeEnv("sonarqube-container") {
           sh "sonar-scanner.bat -Dsonar.projectKey=nagpsonar -Dsonar.sources=. -Dsonar.host.url=http://localhost:9000 -Dsonar.login=0af71ab66ca601daeaddf444f5e292e8d702c4fe"
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
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
  }
}
