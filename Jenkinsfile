pipeline {
    agent any
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
                sh 'ls -l'
                sh 'mvn -DskipTests clean install'
            }
        }
               stage('Deliver for development') {
            when {
                branch 'development'
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
                branch 'production'
            }
            steps {
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
                sh 'docker build -t i_sachinkumar08_develop:${BUILD_NUMBER} --no-cache -f Dockerfile .'
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
