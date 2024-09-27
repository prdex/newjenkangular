pipeline {
    agent any
    // environment {
    //     // Ensure NodeJS is available
    //     PATH = "${env.NODEJS_HOME}/bin:${env.PATH}"
    //     CHROME_BIN = '/usr/bin/google-chrome'  // Path to the Chrome binary
    //     IMAGE_NAME = 'Angulartestimage'
    // }
    stages {
        stage('Print Node Version') {
          
            steps {
                script {
                    // Print Node.js version
                    sh 'node --version'
                }
            }
        }

        stage('Checkout') {
         
            steps {
                // Clone the Git repository
                git 'https://github.com/prdex/newjenkangular.git'
            }
        }

        stage('Install Dependencies') {
        
            steps {
                // Install Node.js dependencies
               // sh 'npm install'

                script {
                    // Cache node_modules and package-lock.json
                    def cacheKey = "${env.WORKSPACE}/node_modules"
                    def lockFile = "${env.WORKSPACE}/package-lock.json"
                    
                    // Check if cache exists
                    if (fileExists(cacheKey) && fileExists(lockFile)) {
                        echo 'Using cached node_modules'
                    } else {
                        echo 'Installing dependencies'
                        sh 'npm install'
                    }
                }
            }
        }

        stage('Build') {
          
            steps {
                // Build the Angular application
                sh 'npm run ng build'
            }
        }
        // stage('Docker Build') {
        //     steps {
        //         script {
        //             // Build Docker image
        //             sh """
        //             docker build -t ${IMAGE_NAME}:latest .
        //             """
        //         }
        //     }
        // }
        
        // stage('Run Docker Container') {
        //     steps {
        //         script {
        //             // Run Docker container
        //             sh """
        //             docker run -d -p 4200:80 ${IMAGE_NAME}:latest
        //             """
        //         }
        //     }
        // }
        // stage('Test') {
        //     steps {
        //         // Run Angular tests
        //         sh 'npm test'
        //     }
        // }
      // stage('Run Unit Tests') {
        //    steps {
                // Run Karma tests
          //      sh 'npx karma start --single-run --browsers ChromeHeadless'
           // }
        //}

       // stage('SCA - npm audit') {
        //    steps {
         //       script {
           //         sh 'node sca.js'
            //    }
            //}
       // }

        // stage('SAST - ESLint') {
        //     steps {
        //         script {
        //             sh 'node sast.js'
        //         }
        //     }
        // }
        // stage('Archive Test Reports') {
        //     steps {
        //         // Archive the generated test reports
        //         archiveArtifacts artifacts: 'test-results/junit.xml', fingerprint: true
        //     }
        // }
        // stage('Serve') {
        //     steps {
        //         // Serve the Angular application locally
        //         sh 'npx http-server dist/ -p 4200'
        //     }
        // }
    }

    post {
      always {
            archiveArtifacts artifacts: 'node_modules/**', fingerprint: true
        }
        success {
          
            echo 'Pipeline succeeded!'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}
