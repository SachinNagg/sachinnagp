pipeline {
    agent any
    environment { 
        DEVELOP_CONTAINER_PORT = 6100
        MASTER_CONTAINER_PORT = 6000
    }
    tools {
        // Install the Maven version configured as "Maven3" and add it to the path.
        maven 'Maven3'
    }
    options
    {
        timeout(time: 1, unit: 'HOURS')
    }
    stages {
        stage('Start') {
            steps {
                checkout scm;
            }
        }
        stage('Build') {
            steps {
                echo ""
                echo '${env.GIT_BRANCH}'
            }
        }
               stage('Deploy for develop') {
            when {
                branch 'develop'
            }
            steps {
                echo "hello! I am in development environment"
                withSonarQubeEnv('Test_Sonar') {
                    echo "Sonar analysis"
                    sh "mvn sonar:sonar"
                }
            }
        }
        stage('Deploy for master') {
            when {
                branch 'master'
            }
            steps {
                echo "hello! I am in master environment"
                echo "UNIT TESTING"
            }
        }
        stage('Containers') {
            parallel {
                stage('PrecontainerCheck') {
                  steps {
                    script {
                      sh '''
                      Port=$MASTER_CONTAINER_PORT
                      
                      if [[ "$GIT_BRANCH" == "develop" ]]
                      then
                      Port=$DEVELOP_CONTAINER_PORT
                      fi
                      
                      echo "${Port}"
                      
                      ContainerID=$(docker ps | grep $Port | cut -d " " -f 1)
                      if [ $ContainerID ]
                      then
                      docker stop $ContainerID
                      docker rm -f $ContainerID
                      fi
                      '''
                    }
                  }
                }
            }
        }
    }
}