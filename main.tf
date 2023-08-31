#Creating bucket

# resource "aws_s3_bucket" "bucket" {
#   bucket = "terraform-nikhil-prac"

#   tags = {
#     Name = "My bucket"
#   }
# }


# # for uploading a pyspark file into a bucket

# resource "aws_s3_object" "upload-glue-script" {
#   bucket = aws_s3_bucket.bucket.id
#   key    = "test.py"
#   source = "./test.py"
# }

# generate an archieve or zip file

data "archive_file" "zip_python_code" {
  type = "zip"
  source_dir = "lm-python.py"
  output_path = "lm-python.zip" 
}

#create Lambda Function
resource "aws_lambda_function" "terraform_lambda_func" {
 filename                       = "lm-python.zip"
 function_name                  = "Jhooq-Lambda-Function"
 role                           = "arn:aws:iam::684710758112:role/LabRole"
 handler                        = "lm-python.lambda_handler"
 runtime                        = "python3.8"
 source_code_hash = filebase64sha256("lm-python.zip")
}

resource "aws_cloudwatch_event_rule" "glue_job_creation_trigger" {
  name        = "GlueJobCreationTriggerRule"
  description = "Trigger Lambda when Glue job is created"
  
  event_pattern = jsonencode({
    source      = ["aws.glue"],
    detail_type = ["Glue Job State Change"],
    detail = {
      eventSource = ["glue.amazonaws.com"],
      eventName   = ["JOB_CREATED"]
    }
  })
}

resource "aws_cloudwatch_event_target" "glue_job_target" {
  rule      = aws_cloudwatch_event_rule.glue_job_creation_trigger.name
  target_id = "GlueJobLambdaTarget"
  
  arn = "arn:aws:iam::684710758112:role/LabRole"
}



resource "aws_glue_job" "glue_job" {
  name = "group2"
  role_arn = "arn:aws:iam::684710758112:role/LabRole"
  description = "This is script to convert dataset"
  max_retries = "1"
  timeout = 2880
  command {
    script_location = "s3://terraform-nikhil-prac/test.py"
    python_version = "3"
  }
  execution_property {
    max_concurrent_runs = 2
  }
  glue_version = "4.0"

}


