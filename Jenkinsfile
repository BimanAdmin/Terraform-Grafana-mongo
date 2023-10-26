pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
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

    stages {
            stage('Update Kubeconfig and Apply YAML Files') {
                steps {
                    script {
                        // Set the AWS region and cluster name
                        def awsRegion = "us-east-2"
                        def eksClusterName = "demo"

                        // Update kubeconfig for the EKS cluster
                        sh "aws eks update-kubeconfig --name $eksClusterName --region $awsRegion"

                        // Verify the kubeconfig was successfully updated
                        if (fileExists("~/.kube/config")) {
                            echo "Kubeconfig updated successfully."
                        } else {
                            error "Failed to update kubeconfig."
                        }

                        // Apply Kubernetes YAML files
                        sh "kubectl apply -f your-manifest.yaml"
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







