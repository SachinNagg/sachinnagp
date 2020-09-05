pipeline {
    agent any
    environment { 
        DEVELOP_DOCKER_PORT = 6100
        MASTER_DOCKER_PORT = 6000
       
        DEVELOP_KUBERNETES_PORT = 30158
        MASTER_KUBERNETES_PORT = 30157
        
        DOCKER_PORT = 6000
        KUBERNETES_PORT = ''
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
                sh 'mvn clean install'
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
                    DOCKER_PORT = MASTER_DOCKER_PORT
                }
                echo "hello! I am in master environment"
                echo "UNIT TESTING"
                sh 'mvn test'
            }
        }
        stage('Upload to Artifactory')  {
            steps {
                rtMavenDeployer(
                    id: 'deployer',
                    serverId: '123456789@artifactory',
                    releaseRepo: 'CI-Automation-JAVA',
                    snapshotRepo: 'CI-Automation-JAVA'
                )
                rtMavenRun(
                    pom: 'pom.xml',
                    goals: 'clean install',
                    deployerId: 'deployer',
                )
                rtPublishBuildInfo(
                    serverId: '123456789@artifactory',
                )
            }
        }
        stage('Docker image') {
            steps {
                sh 'docker build -t dockerabctest/i_sachinkumar08_${GIT_BRANCH}:${BUILD_NUMBER} --no-cache -f Dockerfile .'
            }
        }
        
        stage('Containers') {
            parallel {
                stage('PrecontainerCheck') {
                  steps {
                    script {
                      sh '''
                      echo "${DOCKER_PORT}"
                      
                      ContainerID=$(docker ps | grep $DOCKER_PORT | cut -d " " -f 1)
                      if [ $ContainerID ]
                      then
                      docker stop $ContainerID
                      docker rm -f $ContainerID
                      fi
                      '''
                    }
                  }
                }
                stage('Push to DTR') {
                    steps {
                        sh 'docker push dockerabctest/i_sachinkumar08_${GIT_BRANCH}:${BUILD_NUMBER}'
                    }
                }
            }
        }

        stage('Docker deployment') {
            steps {
                sh 'docker run --name nagp_java_app -d -p 6000:8080 dockerabctest/i_sachinkumar08_${GIT_BRANCH}:${BUILD_NUMBER}'
            }
        }
    }
    post {
        success {
            echo "*************** The pipeline ${currentBuild.fullDisplayName} completed successfully ***************"
        }
        failure {
            echo "*************** The pipeline ${currentBuild.fullDisplayName} has failed ***************"
        }
    }
}
