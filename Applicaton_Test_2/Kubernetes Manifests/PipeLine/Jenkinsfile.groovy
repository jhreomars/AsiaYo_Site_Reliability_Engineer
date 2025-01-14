// Jenkinsfile
pipeline {
    agent {
        kubernetes {
            yaml '''
                apiVersion: v1
                kind: Pod
                spec:
                  containers:
                  - name: docker
                    image: docker:latest
                    command: ['cat']
                    tty: true
                    volumeMounts:
                    - name: docker-sock
                      mountPath: /var/run/docker.sock
                  - name: kubectl
                    image: bitnami/kubectl:latest
                    command: ['cat']
                    tty: true
                  volumes:
                  - name: docker-sock
                    hostPath:
                      path: /var/run/docker.sock
            '''
        }
    }
    
    environment {
        AWS_ACCOUNT_ID = credentials('aws-account-id')
        AWS_REGION = 'ap-northeast-1'
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        IMAGE_NAME = 'asiayo-app'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build and Push') {
            steps {
                container('docker') {
                    script {
                        sh """
                            aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                            docker build -t ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} .
                            docker push ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
                        """
                    }
                }
            }
        }
        
        stage('Deploy') {
            steps {
                container('kubectl') {
                    script {
                        sh """
                            kubectl set image deployment/asiayo-app \
                            asiayo-app=${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} \
                            -n asiayo
                            
                            kubectl rollout status deployment/asiayo-app \
                            -n asiayo --timeout=300s
                        """
                    }
                }
            }
        }
    }
}