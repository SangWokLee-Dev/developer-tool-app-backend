data "archive_file" "archive-file" {
  type        = "zip"
  source_dir  = "lambda/get_jobs_function"
  output_path = "${path.module}/.terraform/archive_files/get_jobs_function.zip"

  depends_on = [null_resource.null_resource]
}

resource "null_resource" "null_resource" {

  triggers = {
    updated_at = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
    yarn
    EOF

    working_dir = "${path.module}/lambda/get_jobs_function"
  }
}

resource "aws_lambda_function" "lambda_function" {
  filename      = "${path.module}/.terraform/archive_files/get_jobs_function.zip"
  function_name = "lambda_function"
  role          = aws_iam_role.lambda-role.arn
  handler       = "index.handler"
  runtime       = "nodejs16.x"
  timeout       = 300

  source_code_hash = data.archive_file.archive-file.output_base64sha256
}

resource "aws_iam_role" "lambda-role" {
  name               = "lambda-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  inline_policy {
    name = "lamda-role-policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "LambdaRolePolicy",
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "lambda:InvokeFunction"
          ],
          "Resource" : "*"
        }
      ]
    })
  }
}