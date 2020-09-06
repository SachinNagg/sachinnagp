pipeline {
    agent any
    environment { 
        DEVELOP_DOCKER_PORT = 6100
        MASTER_DOCKER_PORT = 6000
       
        DEVELOP_KUBERNETES_PORT = 30158
        MASTER_KUBERNETES_PORT = 30157

        image=''
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
                script {
                    env.DOCKER_PORT = DEVELOP_DOCKER_PORT
                    env.KUBERENETES_PORT = DEVELOP_KUBERNETES_PORT
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
                    env.DOCKER_PORT=MASTER_DOCKER_PORT
                    env.KUBERENETES_PORT=MASTER_KUBERNETES_PORT
                }
                echo "hello! I am in master environment"
                echo "UNIT TESTING"
            }
        }

        stage('Docker image') {
            steps {
                script {
                    image = 'dockerabctest/i_sachinkumar08_master:60'
                }
            }
        }
        stage('Helm Chart deployment') {
            steps {
                script {
                    namespace = 'sachinkumar08-java-${GIT_BRANCH}'
                    withCredentials([file(credentialsId: 'KUBECONFIG', variable: 'KUBECONFIG')]) {
                        sh "helm upgrade --install demo-sample-app helm-charts --set image=${image} --set nodePort=$KUBERENETES_PORT --create-namespace ${namespace}"
                    }
                }
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