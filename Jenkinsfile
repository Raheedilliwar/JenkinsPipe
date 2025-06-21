pipeline{
    agent any

    parameters {
        string (name:"IMAGE_NAME" , defaultValue: "myapp")
        string (name:"IMAGE_TAG" , defaultValue: "latest")
        credentials (name:'Docker' , defaultValue:'Docker')
    }
    environment {
        IMAGE = "${params.IMAGE_NAME}:${params.IMAGE_TAG}"
        DOCKER_REGISTRY = "docker.io"
    }
    stages{
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Raheedilliwar/JenkinsPipe.git' , branch: 'main'
            }
        }

        stage ('Build docker image') {
            steps {
                script {
                    bat "docker build -t raheedilliwar/${IMAGE} ."
                }
            }
        }
        stage ('login to dockerhub') {
            steps {
                script{
                    withCredentials([usernamePassword(credentialsId: "${params.DOCKERHUB_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]){
                bat """
                echo $PASS | docker login -u $USER --password-stdin
                docker push raheedilliwar/$DOCKER_IMAGE:$BUILD_NUMBER
                """
                    }
            }
        }
    }

    stage('Push Docker Image') {
            steps {
                script {
                    bat "docker tag ${IMAGE} ${DOCKER_REGISTRY}/${params.IMAGE_NAME}:${params.IMAGE_TAG}"
                    bat "docker push ${DOCKER_REGISTRY}/${params.IMAGE_NAME}:${params.IMAGE_TAG}"
                }
            }
        }

        stage('Logout') {
            steps {
                sh 'docker logout'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
}

}