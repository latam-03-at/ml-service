pipeline {
    agent { label 'project' }

    tools {
        nodejs 'NodeJS'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('david_dockerhub')
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
                sh "curl http://localhost:8088/repository/content-media/ml-media/files.zip --output ${WORKSPACE}/__test__/files.zip"
                sh "unzip ${WORKSPACE}/__test__/files.zip -d ${WORKSPACE}/__test__"
            }
        }
        stage('Unit Tests & Coverage') {
            steps {
                sh "npm test"
            }
            post {
                always{
                    script{
                        sh "rm -rf ${WORKSPACE}/__test__/files"
                        sh "rm -f ${WORKSPACE}/__test__/files.zip"
                    }
                }
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
        stage("Quality Gate"){
            steps{
                waitForQualityGate abortPipeline: true
            }
        }
        stage('Upload to docker hub'){
            steps {
                sh 'docker build -t luisdavidparra/ml-service:${BUILD_NUMBER} .'
                sh 'docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW'
                sh 'docker push luisdavidparra/ml-service:${BUILD_NUMBER}'
            }
            post {
                always {
                    script {
                        sh 'docker logout'
                    }
                }
            }
        }
        //aqui empezamos con CD
        stage('Deploy to staging'){
            steps {
                sh 'bash validate-container2.sh' 
                sh "curl -I http://localhost:3000/api/v1/recognize-objects --silent | grep 404"
            }
        }
        
        stage ('User Acceptance Tests que no pasara') {
            steps {
                sh "curl -I http://localhost:3000/api/v1/recognize-objects --silent | grep 403454"
            }
        }
    }
}