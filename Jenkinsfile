pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AKIAUCTVYSECBZKGGKRU')
        AWS_SECRET_ACCESS_KEY = credentials('V2gIg9Zqy85+p1KOs3oGJXQbvzNRVajRzl9r8zun')
        AWS_DEFAULT_REGION = 'us-east-2' // Change to your desired region
    }
    stages {
        stage("Create an EKS Cluster") {
            steps {
                script {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
}

