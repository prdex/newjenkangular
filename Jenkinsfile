pipeline {
    agent any

    stages {
        stage('Preparation') {
            steps {
                script {
                    // Checkout the code
                 // Fetch the latest changes from the remote repository
                    sh 'git fetch origin'

                    // Check for changes against the origin/master (or your target branch)
                    def changes = sh(script: 'git diff --name-only origin/master', returnStdout: true).trim()
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
                         def targetDir = "${env.WORKSPACE}/artifacts"
                        sh "mkdir -p ${targetDir} && mv ${WORKSPACE}/artifacts/* ${targetDir}/"
                    }
                }
            }
        }

        // stage('Test') {
        //     steps {
        //         sh 'npm test'
        //     }
        // }

        // stage('Deploy') {
        //     steps {
        //         echo 'Deploying application...'
        //     }
        // }
    }

    post {
        always {
            // Archive artifacts in Jenkins' built-in artifact repository
            archiveArtifacts artifacts: 'artifacts/**', fingerprint: true
            
            // Stash the artifacts for future runs
            stash name: 'build-artifacts', includes: 'artifacts/**'
        }
       success {
            archiveArtifacts artifacts: 'artifacts/**', fingerprint: true
            
            // Stash the artifacts for future runs
            stash name: 'build-artifacts', includes: 'artifacts/**'
            echo 'Pipeline succeeded!'
        }

        failure {
          archiveArtifacts artifacts: 'artifacts/**', fingerprint: true
            
            // Stash the artifacts for future runs
            stash name: 'build-artifacts', includes: 'artifacts/**'
            echo 'Pipeline failed.'
        }
    }
}
