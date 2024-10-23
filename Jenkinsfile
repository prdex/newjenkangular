pipeline {
    agent any

    environment {
        IMAGE_NAME = 'my-jenkins-zap'
        CONTAINER_NAME = 'zap-container'
        ZAP_PORT = '8081'
        TARGET_URL = 'http://localhost:4200' // Change to your target URL
        REPORT_FILE = 'zap_report.html'
    }

    stages {
        stage('Preparation') {
            steps {
                script {
                    // Checkout the code
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
                        // Fetch the latest archived artifacts
                        unstash 'build-artifacts'
                        def targetDir = "${env.WORKSPACE}/artifacts"
                        sh "mkdir -p ${targetDir} && mv ${WORKSPACE}/artifacts/* ${targetDir}/"
                    }
                }
            }
        }

        stage('Run ZAP Container') {
            steps {
                script {
                    // Remove any existing ZAP container
                    sh "docker rm -f ${CONTAINER_NAME} || true"
                    // Run the ZAP container
                    sh "docker run -d --name ${CONTAINER_NAME} -p ${ZAP_PORT}:${ZAP_PORT} ${IMAGE_NAME}"
                    // Wait for ZAP to initialize
                    sleep 30
                }
            }
        }

        stage('Start ZAP Scan') {
            steps {
                script {
                    // Start the scan using ZAP API
                    def scanResponse = sh(script: """
                        curl -s -X POST "http://localhost:${ZAP_PORT}/JSON/ascan/action/scan/?url=${TARGET_URL}&apikey=your_api_key"
                    """, returnStdout: true)

                    echo "Scan Response: ${scanResponse}"
                    // Parse the scan ID
                    env.SCAN_ID = scanResponse.token // Adjust if necessary
                }
            }
        }

        stage('Monitor Scan Progress') {
            steps {
                script {
                    def progress = 0
                    while (progress < 100) {
                        sleep 10 // Wait before checking progress
                        progress = sh(script: """
                            curl -s "http://localhost:${ZAP_PORT}/JSON/ascan/view/status/?scanId=${env.SCAN_ID}&apikey=your_api_key" | jq -r '.status'
                        """, returnStdout: true).trim()

                        echo "Scan progress: ${progress}%"
                    }
                }
            }
        }

        stage('Generate ZAP Report') {
            steps {
                script {
                    // Generate the HTML report
                    sh """
                        curl -s "http://localhost:${ZAP_PORT}/OTHER/core/other/htmlreport/?apikey=your_api_key" -o ${REPORT_FILE}
                    """
                    echo "Report generated: ${REPORT_FILE}"
                }
            }
        }

        stage('Stop ZAP Container') {
            steps {
                script {
                    // Stop and remove the ZAP container after testing
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"
                }
            }
        }
    }

    // post {
    //     always {
    //         // Archive artifacts in Jenkins' built-in artifact repository
    //         archiveArtifacts artifacts: 'artifacts/**', fingerprint: true
            
    //         // Stash the artifacts for future runs
    //         dir("${env.WORKSPACE}/artifacts") {
    //             stash name: 'build-artifacts', includes: '**'
    //         }
    //     }

        success {
            echo 'Pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
