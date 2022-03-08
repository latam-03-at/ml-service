pipeline {
    agent any
    
    tools {
        nodejs '16.13.2'
    }
    
    stages {
        stage('Clone repo') {
            steps {
                git branch: 'main', url: 'https://github.com/latam-03-at/ml-service'
            }
        }
        stage('Build') {
            steps {
                sh "cd /var/jenkins_home/workspace/ml-service"
                sh "npm install"
            }
        }
        stage('Build service app') {
            steps {
                sh "cd /var/jenkins_home/workspace/ml-service"
                sh "npm test"
            }
        }
    }
}