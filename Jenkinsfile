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
        //aqui empezamos con CD
        stage('Deploy to staging'){
            steps {
                sh "docker-compose up -d --name ml-service --scale ml-service=1 --force-recreate"
                sleep 15
                /*
                sh 'bash validate-container.sh' 
                sh "docker-compose up -d --name ml-service luisdavidparra/ml-service:$IMAGE_TAG_STG --force-recreate" 
                //sh "docker run -d --name ml-service -p 3000:3000 luisdavidparra/ml-service:$IMAGE_TAG_STG"
                sleep 20*/
            }
        }
        //stage ('User Acceptance Tests que SI pasara') {
        //    steps {
                //sh "curl -i -X POST -H 'Content-type: multipart/form-data' -F images=@Downloads/dog.jpeg -F model="coco" -F object="dog" -F percentage=0.5 10.26.32.243:3000/api/v1/recognize-objects"
                //sh "cd /Users/ubuntu/Downloads curl -i -X POST -H 'Content-type: multipart/form-data' -F images=@dog.jpg -F model="coco" -F object="dog" -F percentage=0.5 10.26.32.243:3000/api/v1/recognize-objects"
        //        sh "curl -I 10.26.32.243:3000/api/v1/recognize-objects --silent | grep 404"
        //    }
        //}
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