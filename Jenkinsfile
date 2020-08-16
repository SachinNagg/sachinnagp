pipeline {
  environment {
    registry = "dockerabctest/registry"
    registryCredential = 'docker'
    dockerImage = ''
  }
  agent any
  tools {nodejs "nodeenv"}
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
              sh "ls"
            }
         }
       }
     }
  }
}
