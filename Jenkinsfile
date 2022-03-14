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
        //aqui empezamos con CD
        //stage('Deploy to staging'){
        //    steps {
                //sh "docker-compose up -d --scale ml-service=1 --force-recreate"
                //sleep 15
                /*
                sh 'bash validate-container.sh' 
                sh "docker-compose up -d --name ml-service luisdavidparra/ml-service:$IMAGE_TAG_STG --force-recreate" 
                //sh "docker run -d --name ml-service -p 3000:3000 luisdavidparra/ml-service:$IMAGE_TAG_STG"
                sleep 20*/
         //   }
        //}

        stage('Create Files') {
            steps {
                sh "curl http://localhost:8088/repository/content-media/ml-media/files.zip --output ${WORKSPACE}/__test__/files.zip"
                sh "unzip ${WORKSPACE}/__test__/files.zip -d ${WORKSPACE}/__test__"
            }
        }
        stage('Show test ls'){
            steps {
                sh "ls __test__/files/decompress"
            }
        }
        stage ('User Acceptance Tests que SI pasara') {
            steps {
                sh "curl -i -X POST -H 'Content-type: multipart/form-data' -F images=@__test__/files/decompress/13.jpg -F model=coco -F object=dog -F percentage=0.5 10.26.32.243:3000/api/v1/recognize-objects"
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
        //stage ('Tag Production Image') {
        //    steps {
        //        sh "docker tag luisdavidparra/ml-service:$IMAGE_TAG_STG luisdavidparra/ml-service:$IMAGE_TAG_PROD"
        //    }
        //}
//
        //stage('Deliver Image for Production') {
        //    steps {
        //        sh "echo $DOCKER_HUB_CREDENTIALS_PSW' | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin"
        //        //sh "docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW"
        //        sh "docker push $FULL_IMAGE_NAME:$IMAGE_TAG_PROD"
        //    }
        //    post {
        //        always {
        //            script {
        //                sh "docker logout"
        //            }
        //        }
        //    }
        //}
    }
}