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
        //Continuous Integration
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
        //end of Continuous Integration

        //start of Continuous Delivery
        stage('Deploy to staging'){
            steps {
                sh "docker-compose up -d --scale ml-service=2 --force-recreate"
                sleep 15
            }
        }
        stage ('User Acceptance Tests') {
            steps {
                sh "curl -i -X POST -H 'Content-type: multipart/form-data' -F images=@__test__/files/decompress/13.jpg -F model=coco -F object=dog -F percentage=0.5 10.26.32.243:3000/api/v1/recognize-objects | grep 200"
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
        stage ('Tag Production Image') {
            steps {
                sh "docker tag luisdavidparra/ml-service:$IMAGE_TAG_STG luisdavidparra/ml-service:$IMAGE_TAG_PROD"
            }
        }
        stage('Deliver Image for Production') {
            steps {
                sh "docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW"
                sh "docker push luisdavidparra/ml-service:$IMAGE_TAG_PROD"
            }
            post {
                always {
                    script {
                        sh "docker logout"
                    }
                }
            }
        }
        //end of continuous delivery
        //continuous deployment
        /*
        stage('Copy files to Server') {
            environment {
                PROD_SERVER = "atuser@20.25.80.241"
                FOLDER_NAME = "ml-service"
                SCRIPT = "validate-container.sh"
                COMPOSE_FILE = "docker-compose.yml"
            }
            steps {
                sshagent(['prod-key']) {
                    sh "ssh -o 'StrictHostKeyChecking no' $PROD_SERVER mkdir -p /home/atuser/$FOLDER_NAME"
                    sh "scp /home/ubuntu/Documents/ml-service/validate-container.sh /home/ubuntu/Documents/ml-service/docker-compose.yml $SERVER_DEV:/home/atuser/$FOLDER_NAME"
                    sh "ssh -o 'StrictHostKeyChecking no' $PROD_SERVER ls -a /home/atuser/$FOLDER_NAME"
                }
            }
        }
        stage('Deploy in prod server') {
            environment {
                PROD_SERVER = "atuser@20.25.80.241"
                FOLDER_NAME = "ml-service"
                SCRIPT = "validate-container.sh"
                COMPOSE_FILE = "docker-compose.yml"
            }
            steps {
                sshagent(['prod-key']) {
                    sh "ssh -o 'StrictHostKeyChecking no' $PROD_SERVER bash /home/atuser/$FOLDER_NAME/validate-container.sh"
                    sh "ssh -o 'StrictHostKeyChecking no' $PROD_SERVER docker-compose up -d"
                }
            }
        }*/
    }
}
