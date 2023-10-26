pipeline {
    agent any

    tools {
            git 'Default' // Use the name of the Git installation you configured in Jenkins
        }

    environment {
        AWS_ACCESS_KEY_ID = credentials('AKIAUCTVYSECBZKGGKRU')
        AWS_SECRET_ACCESS_KEY = credentials('V2gIg9Zqy85+p1KOs3oGJXQbvzNRVajRzl9r8zun')
        AWS_DEFAULT_REGION = 'us-east-2' // Change to your desired region
        TF_CLI_ARGS = "-no-color"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                       // Provide the GitHub repository URL and credentials if needed
                       checkout([$class: 'GitSCM', branches: [[name: 'master']], userRemoteConfigs: [[url: 'https://github.com/BimanAdmin/Terraform-Grafana-mongo.git']]])
                }
            }
        }

        stage('Install and Configure AWS CLI') {
            steps {
                sh 'pip install awscli'
                sh 'aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID'
                sh 'aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY'
                sh 'aws configure set default.region $AWS_DEFAULT_REGION'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init $TF_CLI_ARGS'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan $TF_CLI_ARGS -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply $TF_CLI_ARGS -auto-approve tfplan'
            }
        }

    }

    post {
        success {
            echo 'EKS cluster deployment successful!'
        }
        failure {
            echo 'EKS cluster deployment failed!'
        }
    }
}
