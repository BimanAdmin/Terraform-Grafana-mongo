pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "us-east-1"
    }
    stages {
        stage("Create an EKS Cluster") {
            steps {
                script {
                    dir('terraform') {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
        stage("Deploy to EKS") {
            steps {
                script {
                    dir('kubernetes') {
                        sh "aws eks update-kubeconfig --name demo"
                        sh "kubectl apply -f grafana.yaml"
                        sh "kubectl apply -f nginx.yaml"
                        sh "kubectl apply -f mongo.yaml"
                    }
                }
            }
        }
    }

    post {
                failure {
                    script {
                        echo 'The pipeline has failed. Triggering Terraform destroy...'
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
}



############








