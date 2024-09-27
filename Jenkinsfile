pipeline {
    agent any

    stages {
        stage('Preparation') {
            steps {
                script {
                    // Checkout the code
                    checkout scm
                    
                    // Check for changes in the repository
                    def changes = sh(script: 'git diff --name-only HEAD HEAD~1', returnStdout: true).trim()
                    env.HAS_CHANGES = changes ? 'true' : 'false'
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    // Check if there are changes
                    if (env.HAS_CHANGES == 'true') {
                        echo 'Changes detected. Building the project...'
                        sh 'npm install'
                        sh 'npm run build'
                        
                        // Store the artifacts
                        def artifactsDir = "${env.WORKSPACE}/artifacts"
                        sh "mkdir -p ${artifactsDir} && cp -r dist/* ${artifactsDir}/"
                    } else {
                        echo 'No changes detected. Fetching the latest artifacts...'
                        // This will fetch the latest archived artifacts
                        unstash 'build-artifacts'
                    }
                }
            }
        }

        stage('Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
            }
        }
    }

    post {
        always {
            // Archive artifacts in Jenkins' built-in artifact repository
            archiveArtifacts artifacts: 'artifacts/**', fingerprint: true
            
            // Stash the artifacts for future runs
            stash name: 'build-artifacts', includes: 'artifacts/**'
        }
       success {
          
            echo 'Pipeline succeeded!'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}
