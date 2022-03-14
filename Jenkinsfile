pipeline {
    agent { label 'project' }
    /*parameters {
        choice(name: 'Environment', choices: ['Development', 'Production'], description: 'Choose an environment where deploy the Database')
        string(name: 'BuildNumber', defaultValue: ':', description: '')
    }*/
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
        
        //aqui empezamos con Continuous Delivery
        /*
        stage('Deploy to staging'){
            steps {
                sh "docker-compose up -d --scale ml-service=1 --force-recreate"
                sleep 15
                
                //sh 'bash validate-container.sh' 
                //sh "docker-compose up -d --name ml-service luisdavidparra/ml-service:$IMAGE_TAG_STG --force-recreate" 
                //sh "docker run -d --name ml-service -p 3000:3000 luisdavidparra/ml-service:$IMAGE_TAG_STG"
                //sleep 20
            }
        }
        stage ('User Acceptance Tests') {
            steps {
                //sh "curl -i -X POST -H 'Content-type: multipart/form-data' -F images=@Downloads/dog.jpeg -F model="coco" -F object="dog" -F percentage=0.5 10.26.32.243:3000/api/v1/recognize-objects"
                //sh "cd /Users/ubuntu/Downloads curl -i -X POST -H 'Content-type: multipart/form-data' -F images=@dog.jpg -F model="coco" -F object="dog" -F percentage=0.5 10.26.32.243:3000/api/v1/recognize-objects"
                //sh "curl -I 10.26.32.243:3000/api/v1/recognize-objects --silent | grep 404"
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
        */
        //Continuous Deployment Pipeline
        stage ('Download Image') {
            steps {
                sshagent(['azure']) {
                    sh "ssh -o 'StrictHostKeyChecking no' calebespinoza@20.25.119.241 docker pull luisdavidparra/ml-service:$IMAGE_TAG_STG"
                    //sh "scp $ENV_FILE $SCRIPT $COMPOSE_FILE $PROD_SERVER:~/$FOLDER_NAME" //poner bien esos archivos
                    sh "docker images"
                }
            }
        }/*
        stage ('Validate if container exists') {
            steps {
                sshagent(['azure'])
            }
        }*/
    }
}