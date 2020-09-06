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
        timestamps()
        timeout(time: 1, unit: 'HOURS')

        skipDefaultCheckout()

        buildDiscarder(logRotator(numToKeepStr: '1'))
        disableConcurrentBuilds()
    }
    stages {
        stage('Start') {
            steps {
                checkout scm;
            }
        }
        stage('Build') {
            steps {
                echo '${env.BRANCH_NAME}'
                // sh 'mvn clean install'
            }
        }
        // stage('Sonar Analysis') {
        //     when {
        //         branch 'develop'
        //     }
        //     steps {
        //         echo 'hello! I am in development environment'
        //         script {
        //             env.DOCKER_PORT = DEVELOP_DOCKER_PORT
        //             env.KUBERENETES_PORT = DEVELOP_KUBERNETES_PORT
        //         }
        //         withSonarQubeEnv('Test_Sonar') {
        //             sh 'mvn sonar:sonar'
        //         }
        //     }
        // }
        // stage('Unit Testing') {
        //     when {
        //         branch 'master'
        //     }
        //     steps {
        //         echo 'hello! I am in master environment'
        //         script {
        //             env.DOCKER_PORT=MASTER_DOCKER_PORT
        //             env.KUBERENETES_PORT=MASTER_KUBERNETES_PORT
        //         }
        //         sh 'mvn test'
        //     }
        // }
        // stage('Upload to Artifactory')  {
        //     steps {
        //         rtMavenDeployer(
        //             id: 'deployer',
        //             serverId: '123456789@artifactory',
        //             releaseRepo: 'CI-Automation-JAVA',
        //             snapshotRepo: 'CI-Automation-JAVA'
        //         )
        //         rtMavenRun(
        //             pom: 'pom.xml',
        //             goals: 'clean install',
        //             deployerId: 'deployer',
        //         )
        //         rtPublishBuildInfo(
        //             serverId: '123456789@artifactory',
        //         )
        //     }
        // }
        // stage('Docker Image') {
        //     steps {
        //         script {
        //             image = 'dockerabctest/i_sachinkumar08_${GIT_BRANCH}:${BUILD_NUMBER}'
        //         }
        //         sh "docker build -t ${image} --no-cache -f Dockerfile ."
        //     }
        // }
        // stage('Containers') {
        //     parallel {
        //         stage('PrecontainerCheck') {
        //           steps {
        //             script {
        //               sh '''
        //                 Port=$DOCKER_PORT
        //                 ContainerID=$(docker ps | grep $Port | cut -d " " -f 1)
        //                 if [ $ContainerID ]
        //                 then
        //                 docker stop $ContainerID
        //                 docker rm -f $ContainerID
        //                 fi
        //               '''
        //             }
        //           }
        //         }
        //         stage('Push to DTR') {
        //             steps {
        //                 sh "docker push ${image}"
        //             }
        //         }
        //     }
        // }
        // stage('Docker deployment') {
        //     steps {
        //         sh "docker run --name c_sachinkumar08_\${GIT_BRANCH} -d -p ${DOCKER_PORT}:8080 ${image}"
        //     }
        // }
        // stage('Helm Chart deployment') {
        //     steps {
        //         script {
        //             /**
        //               * Sharing namespace as per the branch
        //              */
        //             namespace = 'sachinkumar08-java-${GIT_BRANCH}'
                    
        //             // withCredentials([file(credentialsId: 'KUBECONFIG', variable: 'KUBECONFIG')]) {
        //                 /**
        //                 * Using latest helm 3.3.1 with --create-namespace flag to create ns.
        //                 * Also, using helm upgrade --install to create/update on the same port
        //                 */
        //                 sh "helm upgrade --install demo-sample-app helm-charts --set image=${image} --set nodePort=$KUBERENETES_PORT --create-namespace -n ${namespace}"
        //             // }
        //         }
        //     }
        // }
    }
    post {
        always {
            junit 'target/surefire-reports/*.xml'
        }
    }
}