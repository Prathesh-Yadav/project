pipeline {
    agent {
        label "docker"
    }
    environment {
        TAG_FILE = '/home/docker/workspace/latest_tag.txt'  // Path to store the latest tag
    }
    stages {
        stage('Fetch Tags from Nexus') {
            steps {
                script {
                    // Nexus URL to access components and tags
                    def NEXUS_URL = "http://13.233.8.58:8081/service/rest/v1/components?repository=carapp_docker"
                    def NEXUS_USERNAME = "admin"
                    def NEXUS_PASSWORD = "admin"

                    // Fetch tags from Nexus using curl
                    def response = sh(
                        script: "curl -u ${NEXUS_USERNAME}:${NEXUS_PASSWORD} -s ${NEXUS_URL}",
                        returnStdout: true
                    ).trim()

                    // Print the raw response for debugging
                    echo "Response from Nexus: ${response}"

                    // Parse the response as JSON and extract tags
                    def jsonResponse = readJSON text: response
                    def tags = []

                    // Extract tags from the response (assuming "version" holds tag information)
                    jsonResponse.items.each { item ->
                        if (item.version) {
                            tags.add(item.version)
                        }
                    }

                    // Print the tags found
                    if (tags.size() > 0) {
                        echo "Tags found in Nexus: ${tags.join(', ')}"

                        // Get the latest tag from the list (assuming the tags follow the format X.Y)
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
                        def newTag = "${major}.${minor}"

                        echo "New tag to be used: ${newTag}"

                        // Save the new tag to the file
                        writeFile file: TAG_FILE, text: newTag
                    } else {
                        // If no tags found, use a default tag
                        def defaultTag = "1.0" // Set default tag
                        echo "No tags found in Nexus, using default tag: ${defaultTag}"

                        // Save the default tag to the file
                        writeFile file: TAG_FILE, text: defaultTag
                    }
                }
            }
        }
    }
}
