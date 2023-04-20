pipeline{
    agent any
    stages{
        stage("TF Init"){
            steps{
                echo "Executing Terraform Init"
                script {
                    sh("terraform init")
                }
            }
        }
        stage("TF Validate"){
            steps{
                echo "Validating Terraform Code"
                script {
                    sh("terraform validate")
                }
            }
        }
        stage("TF Plan"){
            steps{
                echo "Executing Terraform Plan"
                script {
                    sh("terraform plan -out=saved-plan")
                }
            }
        }
        stage("TF Apply"){
            steps{
                echo "Executing Terraform Apply"
                script {
                    sh("terraform apply saved-plan")
                    env.LAMBDA_FUNCTION_NAME = sh(returnStdout: true, script: """
                        terraform output -raw LAMBDA_FUNCTION_NAME
                    """).trim()
                    }
            }
        }
        stage("Invoke Lambda"){
            steps{
                echo "Invoking your AWS Lambda"
                script {
                    sh("aws lambda invoke --function-name ${env.LAMBDA_FUNCTION_NAME} --log-type Tail")
                }
            }
        }
    }
    post {
        always {
            script {
                cleanWs()
            }
        }
    }
}
