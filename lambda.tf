data "archive_file" "lambda_devops_exam" {
  type = "zip"

  source_file   = "${path.module}/candidateEmail.py"
  output_path   = "${path.module}/candidateEmail.zip"
}

resource "aws_lambda_function" "terraform_lambda_function" {
    filename                       = "${path.module}/candidateEmail.zip"
    function_name                  = "${var.name}-candidate-exam"
    role                           = data.aws_iam_role.lambda.arn
    handler                        = "candidateEmail.lambda_handler"
    runtime                        = "python3.8"
    timeouts                       = 30

    # Used to trigger updates
    source_code_hash = data.archive_file.lambda_devops_exam.output_base64sha256

    vpc_config {
        subnet_ids         = [element(aws_subnet.private[*].id, 0)]
        security_group_ids = [aws_security_group.lambda.id]
    }

    environment {
        variables = {
            API_ENDPOINT    = var.API_ENDPOINT
            SUBNET_ID       = element(aws_subnet.private[*].id, 0)
            CANDIDATE_NAME  = var.CANDIDATE_NAME
            CANDIDATE_EMAIL = var.CANDIDATE_EMAIL
        }
    }
}
