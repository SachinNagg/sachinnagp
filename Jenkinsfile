pipeline {
    agent any
    environment { 
        DEVELOP_DOCKER_PORT = 6100
        MASTER_DOCKER_PORT = 6200
       
        DEVELOP_KUBERNETES_PORT = 30158
        MASTER_KUBERNETES_PORT = 30157

        image=''
    }
    tools {
        maven 'Maven3'
    }
    options
    {
        timestamps()
        timeout(time: 1, unit: 'HOURS')

        skipDefaultCheckout()

        buildDiscarder(logRotator(numToKeepStr: '1'))
        disableConcurrentBuilds()
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage('Sonar Analysis') {
            when {
                branch 'develop'
            }
            steps {
                script {
                    env.DOCKER_PORT = DEVELOP_DOCKER_PORT
                    env.KUBERENETES_PORT = DEVELOP_KUBERNETES_PORT
                
                    def scannerHome = tool 'SonarQubeScanner';
                    withSonarQubeEnv("Test_Sonar") {
                        // sh "mvn sonar:sonar"
                        bat "${scannerHome}\\bin\\sonar-scanner.bat -Dproject.settings=./sonar-project.properties"
                    }
                }
            }
        }
        stage('Unit Testing') {
            when {
                branch 'master'
            }
            steps {
                script {
                    env.DOCKER_PORT=MASTER_DOCKER_PORT
                    env.KUBERENETES_PORT=MASTER_KUBERNETES_PORT
                }
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
        stage('Docker Image') {
            steps {
                script {
                    image = 'dtr.nagarro.com:443/i-sachinkumar08-${BRANCH_NAME}:${BUILD_NUMBER}'
                    sh "docker build -t ${image} --no-cache -f Dockerfile ."
                }
            }
        }
        stage('Containers') {
            parallel {
                stage('PrecontainerCheck') {
                  steps {
                    script {
                      sh '''
                        Port=$DOCKER_PORT
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
                stage('Push to DTR') {
                    steps {
                        sh "docker push ${image}"
                    }
                }
            }
        }
        stage('Docker deployment') {
            steps {
                script {
                    container = "c-sachinkumar08-\${BRANCH_NAME}"
                    sh "docker run --name ${container} -d -p ${DOCKER_PORT}:8080 ${image}"
                }
            }
        }
        stage('Helm Chart deployment') {
            steps {
                script {
                    // Sharing namespace as per the branch
                    namespace = 'sachinkumar08-java-${BRANCH_NAME}'
                    
                    // withCredentials([file(credentialsId: 'KUBECONFIG',variable: 'KUBECONFIG')]) {
                        /**
                            * Using latest helm 3.3.1 with --create-namespace flag to create ns.
                            * Also, using helm upgrade --install to create/update on the same port
                        */
                        sh "helm upgrade --install demo-sample-app helm-charts --set image=${image} --set nodePort=$KUBERENETES_PORT --set containerName=${container} --create-namespace -n ${namespace}"
                    // }
                }
            }
        }
    }
    post {
        always {
           script {
                junit '**/test-reports/.*xml'
            }
        }
    }
}