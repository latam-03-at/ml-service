pipeline {
    agent { label 'project' }

    tools {
        nodejs 'NodeJS'
    }


    stages {
        stage('Clone repo') {
            steps {
                git branch: 'main', url: 'https://github.com/latam-03-at/ml-service'
            }
        }
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
                sh "cd ${WORKSPACE}"
                sh "cd __test__"
                sh "mkdir files"
                sh "curl http://localhost:8088/repository/content-media/ml-media/files.zip --output /files/files.zip"
                sh "cd files"
                sh "unzip files.zip"
            }
        }

        stage('Unit Tests & Coverage') {
            steps {
                sh "npm test"
            }
        }
    }
}
        
        