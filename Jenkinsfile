## this file we have to write in the Jenkins Pipeline 
pipeline {
	agent any 
	
	tools {
		jdk 'jdk17'
		maven 'maven3'
		}

    environment {
        Scanner_Home = tool 'sonar-scanner'
    }	
	
	stages {
		stage('git checkout'){
			steps {
				git branch: 'main', credentialsID: 'git-cred', url: 'https://UR URL'
				}
			}
			
	stages {
		stage ('Compile') {
			steps {
				sh "mvn compile"
				}
			}
			
	stages {
		stage ('Test') {
			steps {
				sh "mvn test"
				}
			}

	stages {
		stage ('File system scan') {      #install the trivy on the jenkins for use this
			steps {
				sh "trivy fs --format table -o trivy-fs-report.html ."
				}
			}

	stages {
		stage ('SonarQube Analysis') {    #we have to configure the SonarQube server to use it
			steps {
				withSonarQubeEnv('sonar'){
                    sh '''$Scanner_Home/bin/sonar-scanner -Dsonar.projectName=PipelinePalooza -Dsonar.projectKey -Dsonar.projectKey=PipelinePalooza \
                    -Dsonar.java.binaries=. '''
                }
            
			}
		}
			
	stages {
		stage ('Quality Gate') {         # to do this we have to create the webhook
			steps {
				waitForQualityGate abortPipeline: false, credentialsID: 'sonar-token'
				}
			}	
	
	stages {
		stage ('Build') {
			steps {
				sh "mvn package"
				}
			}
	
		stages {
		stage ('Publish Artifacts to nexus ') {  # add the repository url in the POM.xml file
			steps {                             # and configure its creds in the jenkins
				withMaven(global)MavenSettingsConfig: 'global-settings', jdk: 'jdk17' ,maven: 'maven3' MavenSettingsConfig: ",tracebility: true"
                {
                sh "mvn deploy"
                }
			}
		}

    	stages {
		stage ('Build & Tag Docker Image') {
			steps {
                script{
                    withDockerRegistry(credentialsID: 'docker-cred', toolname: 'docker'){
                        sh "docker build -t asif/piplinepalooza:latest ."
                        }
                    }
				}
			}
	
	stages {
		stage ('Docker Image Scan') {
			steps {
				sh "trivy image --format table -o trivy-fs-report.html asif/piplinepalooza:latest"
				}
			}

    	stages {
		stage ('Push Docker Image') {
			steps {
                script{
                    withDockerRegistry(credentialsID: 'docker-cred', toolname: 'docker'){
                        sh "docker push asif/piplinepalooza:latest "
                        }
                    }
				}
			}
	}
