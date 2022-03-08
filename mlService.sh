pipeline {
    agent any
    tools {
        nodejs 'NodeJS'
    }
    stages {
        stage('Stage 1') {
            steps {
                echo 'Hello world!' 
            }
        }
        stage('Stage 2') {
            steps {
                git branch: 'main', url: 'https://github.com/latam-03-at/ml-service.git'
            }
        }
        stage('Stage 3') {
            steps {
                sh 'apt-get update || : && apt-get install -y python build-essential'
                sh 'cd /var/jenkins_home/workspace/ml-service'
            }
        }
    }
}
