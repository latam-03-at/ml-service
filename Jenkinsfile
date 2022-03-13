pipeline {
    agent { label 'project' }

    tools {
        nodejs 'NodeJS'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('david_dockerhub')
        IMAGE_TAG_STG = "$BUILD_NUMBER-stg"
        IMAGE_TAG_PROD = "$BUILD_NUMBER-prod"
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
                sh "docker build -t luisdavidparra/ml-service:$IMAGE_TAG_STG  ."
                sh "docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW"
                sh "docker push luisdavidparra/ml-service:$IMAGE_TAG_STG "
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
                sh 'bash validate-container.sh' 
                sh "docker-compose up -d --name ml-service luisdavidparra/ml-service:$IMAGE_TAG_STG --force-recreate" 
                //sh "docker run -d --name ml-service -p 3000:3000 luisdavidparra/ml-service:$IMAGE_TAG_STG"
                sleep 20
            }
        }
        stage ('User Acceptance Tests que SI pasara') {
            steps {
                //sh "curl -i -X POST -H 'Content-type: multipart/form-data' -F images=@Downloads/dog.jpeg -F model="coco" -F object="dog" -F percentage=0.5 10.26.32.243:3000/api/v1/recognize-objects"
                //sh "cd /Users/ubuntu/Downloads curl -i -X POST -H 'Content-type: multipart/form-data' -F images=@dog.jpg -F model="coco" -F object="dog" -F percentage=0.5 10.26.32.243:3000/api/v1/recognize-objects"
                sh "curl -I 10.26.32.243:3000/api/v1/recognize-objects --silent | grep 404"
            }
        }
        stage ('Tag Production Image') {
            steps {
                sh "docker tag luisdavidparra/ml-service:$IMAGE_TAG_STG luisdavidparra/ml-service:$IMAGE_TAG_PROD"
            }
        }

        stage('Deliver Image for Production') {
            steps {
                sh "echo $DOCKER_HUB_CREDENTIALS_PSW' | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin"
                //sh "docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW"
                sh "docker push $FULL_IMAGE_NAME:$IMAGE_TAG_PROD"
            }
            post {
                always {
                    script {
                        sh "docker logout"
                    }
                }
            }
        }
    }
}