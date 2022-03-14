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
         stage ('Download Image') {
            steps {
                sshagent(['azure']) {
                    //sh "ssh -o 'StrictHostKeyChecking no' calebespinoza@20.25.119.241 docker pull luisdavidparra/ml-service:$IMAGE_TAG_STG"
                    //sh "scp $ENV_FILE $SCRIPT $COMPOSE_FILE $PROD_SERVER:~/$FOLDER_NAME" //poner bien esos archivos
                    sh "ssh -o 'StrictHostKeyChecking no' calebespinoza@20.25.119.241 docker images"
                }
            }
        }/*
    }
}