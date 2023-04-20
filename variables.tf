variable "name" {
    type = string
    default = "suchak"
}

variable "CANDIDATE_NAME" {
    type = string
    default = "Suchak (https://github.com/suchak-patel/devops-candidate-exam)"
}

variable "CANDIDATE_EMAIL" {
    type = string
    default = "suchak.patel@siemens.com"
}

variable "API_ENDPOINT" {
    type = string
    default = "https://ij92qpvpma.execute-api.eu-west-1.amazonaws.com/candidate-email_serverless_lambda_stage/data"
}

variable "vpc_private_subnets" {
    type = list
    default = [
        "10.0.14.0/24"
    ]
}

