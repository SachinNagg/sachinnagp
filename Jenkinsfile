pipeline {
    agent any
    environment { 
        DEVELOP_DOCKER_PORT=6100
        MASTER_DOCKER_PORT = 6000
        DOCKER_PORT=''
        DEVELOP_KUBERNETES_PORT = 30158
        MASTER_KUBERNETES_PORT = 30157
        
        KUBERNETES_PORT = ''

        image = ''
    }
    tools {
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
        stage('Deploy for develop') {
            when {
                branch 'develop'
            }
            steps {
                echo "hello! I am in development environment"
                script {
                    DOCKER_PORT = DEVELOP_DOCKER_PORT
                }
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
                script {
                    echo MASTER_DOCKER_PORT
                    echo "changing master port value"
                    DOCKER_PORT=MASTER_DOCKER_PORT
                    echo DOCKER_PORT
                }
                
                echo "TEST_VARIABLE = ${DOCKER_PORT}"

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
                      Port=$DOCKER_PORT
                      
                      echo "${Port}"

                      Port=${DOCKER_PORT}
                      echo "${Port}"

                     echo "TEST_VARIABLE = ${DOCKER_PORT}"

                    echo $DOCKER_PORT
 
                      Port=$MASTER_DOCKER_PORT
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