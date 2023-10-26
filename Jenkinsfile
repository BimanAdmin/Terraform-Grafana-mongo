pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'us-east-2' // Change to your desired region
        KUBECONFIG = 'C:\\Users\\biman\\.kube\\config'
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


        stage("Deploy to Kubernetes") {
            steps {
                script {
                      // Apply Kubernetes Grafana YAML
                      sh "kubectl apply -f ./grafana.yaml --kubeconfig=${KUBECONFIG}"

                      // Apply Kubernetes Mongo YAML
                      sh "kubectl apply -f ./mongo.yaml --kubeconfig=${KUBECONFIG}"

                      // Apply Kubernetes Nginx YAML
                      sh "kubectl apply -f ./nginx.yaml --kubeconfig=${KUBECONFIG}"
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







