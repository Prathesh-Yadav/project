pipeline {
  agent {
    label "java"
  }
  environment {
    PATH = "/apache-maven-3.9.9/bin:/usr/bin:/bin:/usr/local/bin"
    dockerRepoUrl1 = "http://13.233.32.31:5067/repository/carapp_docker"
	}

  stages {

    stage('Build') {
      steps {
        sh 'mvn clean install'
      }
    }

    stage('jacoco') {
      steps {
        jacoco()
      }
    }
    
    stage('SonarQube analysis') {
      steps {
        script {
          def scannerHome = tool 'scanner_sonar'
          withSonarQubeEnv('jenkins-sonar') {
            sh """
              ${scannerHome}/bin/sonar-scanner \
              -Dsonar.projectKey=javawebapp \
              -Dsonar.projectName=javawebapp \
              -Dsonar.projectVersion=1.0 \
              -Dsonar.java.binaries='target/classes'
            """
          }
        }
      }
    }
    /*
    stage("Sonar Quality Gate Check") {
      steps {
        timeout(time: 1, unit: 'HOURS') {
          script {
            def qualityGate = waitForQualityGate()
            if (qualityGate.status != 'OK') {
              error "Pipeline aborted due to quality gate failure: ${qualityGate.status}"
            }
          }
        }
      }
    }
*/
    stage('Upload to Nexus') {
      steps {
        nexusArtifactUploader(
          artifacts: [[
            artifactId: 'SimpleWebApplication', 
            classifier: '', 
            file: 'target/SimpleWebApplication.war', 
            type: 'war'
          ]], 
          credentialsId: 'nexus', 
          groupId: 'com.maven', 
          nexusUrl: '13.233.32.31:8081/', 
          nexusVersion: 'nexus3', 
          protocol: 'http', 
          repository: 'carapp', 
          version: '1.0.0-SNAPSHOT'
        )
      }
    }
/*
 stage('Debug Docker Login and Registry Access') {
        steps {
        	withCredentials([usernamePassword(credentialsId: 'nexus', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh """
                    echo $DOCKER_PASSWORD | docker login --insecure-registry http://13.233.32.31:5067 --username $DOCKER_USERNAME --password-stdin
                    curl -I http://13.233.32.31:5067/v2/
                    """
                }
            }
        }
*/
stage('Download Latest WAR from Nexus, Build image and push back to Nexus') {
    agent {
        label "docker"
    }
            steps {
                script {
                    def dockerImageName = "carapp"
                    def dockerRepoUrl = "http://13.233.32.31:8081/service/rest/v1/components?repository=carapp_docker"
                    def defaultTag = "1.0" // Default tag if no tags are found
                    def newTag = ""

                    echo "Fetching existing tags from the repository..."

                    // Fetch tags from Nexus using curl
                    def response = sh(
                        script: "curl -u admin:admin -s ${dockerRepoUrl}/v2/${dockerImageName}/tags/list",
                        returnStdout: true
                    ).trim()

                    // Print the raw response for debugging
                    echo "Response from Nexus: ${response}"

                    // Parse the response as JSON and extract tags
                    def tags = []
                    if (response) {
                        def jsonResponse = readJSON text: response
                        if (jsonResponse?.tags) {
                            tags = jsonResponse.tags
                        }
                    }

                    if (tags.size() > 0) {
                        // If tags exist, determine the latest tag and increment it
                        echo "Tags found in Nexus: ${tags.join(', ')}"

                        def maxTag = tags.max { a, b ->
                            // Compare tags by their numeric values
                            def aParts = a.split('\\.')
                            def bParts = b.split('\\.')
                            return [aParts[0].toInteger(), aParts[1].toInteger()] <=> [bParts[0].toInteger(), bParts[1].toInteger()]
                        }

                        echo "Latest tag found: ${maxTag}"

                        // Increment the version by 0.1
                        def parts = maxTag.split('\\.')
                        def major = parts[0].toInteger()
                        def minor = parts[1].toInteger() + 1 // Increment the minor version by 1
                        newTag = "${major}.${minor}"
                        echo "New tag to be used: ${newTag}"
                    } else {
                        // If no tags exist, use the default tag
                        echo "No tags found in Nexus, using default tag: ${defaultTag}"
                        newTag = defaultTag
                    }

                    // Build the Docker image
                    echo "Building the Docker image with tag ${newTag}..."
	 withCredentials([usernamePassword(credentialsId: 'nexus', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
         sh """
                echo \$DOCKER_PASSWORD | docker login http://13.233.32.31:5067 --username \$DOCKER_USERNAME --password-stdin
		curl -I http://13.233.32.31:5067/v2/
                docker build -t ${dockerImageName}:${newTag} -f docker/Dockerfile docker
                docker tag ${dockerImageName}:${newTag} 13.233.32.31:5067/repository/carapp_docker/carapp:${newTag}
                docker push 13.233.32.31:5067/repository/carapp_docker/carapp:${newTag}
            """
        		}
                }
            }
        }
}
}
