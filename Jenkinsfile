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
		stage ('Start') {
			steps {
				checkout scm;
			}
		}
          
        stage('Build') {
            steps {
                echo "*************** building the project ***************"
				// Run Maven on a Unix agent.
                sh 'mvn -DskipTests clean install'
            }
        }
        
        stage('UNIT TESTING') {
            steps {
				echo "*************** Executing Unit test cases ***************"
				// Run Maven on a Unix agent.
                sh 'mvn test'
            }
        }
		stage ('Upload to Artifactory')
		{
			steps
			{
				echo "*************** Uploading artifacts to Artifactory ***************"
				rtMavenDeployer (
                    id: 'deployer',
                    serverId: '123456789@artifactory',
                    releaseRepo: 'CI-Automation-JAVA',
                    snapshotRepo: 'CI-Automation-JAVA'
                )
                rtMavenRun (
                    pom: 'pom.xml',
                    goals: 'clean install',
                    deployerId: 'deployer',
                )
                rtPublishBuildInfo (
                    serverId: '123456789@artifactory',
                )
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
