pipeline {
    agent { label 'project' }

    tools {
        nodejs 'NodeJS'
    }


    stages {
        
        stage('Python') {
            steps {
                echo "install python"
                sh "sudo apt-get install -y python build-essential"
                sh "python -V"
            }
        }
        stage('Install') {
            steps {
                sh "npm install"
            }
        }

        stage('Create Files') {
            steps {
                sh "curl http://localhost:8088/repository/content-media/ml-media/files.zip --output ${WORKSPACE}/files.zip"
                sh "unzip files.zip"
                sh "mv files __test__"
            }
        }

        stage('Unit Tests & Coverage') {
            steps {
                sh "npm test"
            }
        }
        stage('SonarQube analysis') {
            steps{
                script{
                    def scannerHome = tool 'flor-sonar';
                    def scannerParameters = "-Dsonar.projectName=ml_ci " +
                        "-Dsonar.projectKey=ml_ci -Dsonar.sources=. "+
                        "-Dsonar.javascript.lcov.reportPaths=${WORKSPACE}/coverage/lcov.info"
                    withSonarQubeEnv('devops') { 
                        sh "${scannerHome}/bin/sonar-scanner ${scannerParameters}"  
                    }
                }
            }
        }
    }
}
        