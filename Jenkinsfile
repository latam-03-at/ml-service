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

        stage('Unit Tests & Coverage') {
            steps {
                sh "npm test"
            }
        }
    }
}
        
        