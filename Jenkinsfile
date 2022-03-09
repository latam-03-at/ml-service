pipeline {
    agent { label 'agent_project' }

    tools {
        nodejs 'NodeJS'
    }


    stages {
    // Continuous Integration Pipeline
        stage('Clone repo') {
            steps {
                git branch: 'main', url: 'https://github.com/latam-03-at/ml-service'
            }
        }
        stage('Install') {
            steps {
                sh "sudo apt install python2.7"
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
        
        