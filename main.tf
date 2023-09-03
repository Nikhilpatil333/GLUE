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
#=======================================================================================
# generate an archieve or zip file

# data "archive_file" "zip_file" {
#   type        = "zip"
#   source_dir  = "C:/Users/svdn/OneDrive/Desktop/terraform/tf codes for GLUE JOB/lm-python.py"
#   output_path = "C:/Users/svdn/OneDrive/Desktop/terraform/tf codes for GLUE JOB/lm-python.zip"
# }
#=======================================================================================

 


# create Lambda Function

# 1st create lambda function and copy the lambda ARN and paste in cloudwatch block 

# resource "aws_lambda_function" "glue_job_trigger_lambda" {
#  filename                       = "${path.module}/lm.zip"
#  function_name                  = "Jhooq-Lambda-Function"
#  role                           = "arn:aws:iam::684710758112:role/LabRole"
#  handler                        = "lm.lambda_handler"
#  runtime                        = "python3.11"
# }

# CLOUDWATCH 

# resource "aws_cloudwatch_event_rule" "glue_job_creation_trigger" {
#   name        = "GlueJobCreationTriggerRule"
#   description = "Trigger Lambda when Glue job is created"
  
#   event_pattern = jsonencode({
#     source      = ["aws.glue"],
#     detail_type = ["Glue Job State Change"],

#     detail = {
#       eventSource = ["glue.amazonaws.com"],
#       eventName   = ["JOB_CREATED"]
#     }
#   })
# }

# resource "aws_cloudwatch_event_target" "glue_job_target" {
#   rule      = aws_cloudwatch_event_rule.glue_job_creation_trigger.name
#   target_id = "GlueJobLambdaTarget"
  
#   arn = aws_lambda_function.glue_job_trigger_lambda.arn  #"arn:aws:lambda:us-east-1:684710758112:function:Jhooq-Lambda-Function"
# }


# # Grant necessary permissions to Lambda function to start Glue job
# resource "aws_lambda_permission" "glue_job_trigger_permission" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.glue_job_trigger_lambda.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.glue_job_creation_trigger.arn
# }

  




# # GLUE JOB
resource "aws_glue_job" "glue_job" {
  name = "group2"
  role_arn = "arn:aws:iam::684710758112:role/LabRole"
  description = "This is script to convert dataset"
  max_retries = "0"
  timeout = 120
  number_of_workers = 2
  worker_type = "Standard"
  command {
    script_location = "s3://terraform-nikhil-prac/test.py"
    python_version = "3"
  }
  execution_property {
    max_concurrent_runs = 2
  }
  glue_version = "4.0"
  
}

# STEP FUNCTION TO TRIGGER GLUE JOB
# Define an SNS topic
resource "aws_sns_topic" "glue_job_notification" {
  name = "glue-job-notification-topic"
}

# STEP FUNCTION TO TRIGGER GLUE JOB AND NOTIFY
resource "aws_sfn_state_machine" "glue_job_trigger" {
  name     = "glue-job-trigger"
  role_arn = "arn:aws:iam::684710758112:role/LabRole"

  definition = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "TriggerGlueJob",
  "States": {
    "TriggerGlueJob": {
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName": "${aws_glue_job.glue_job.name}"
      },
      "End": false,
      "Next": "WaitForGlueJob"
    },
    "WaitForGlueJob": {
      "Type": "Wait",
      "Seconds": 90,  
      "Next": "SNSPublish"
    },
    "SNSPublish": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "TopicArn": "${aws_sns_topic.glue_job_notification.arn}",
        "Message": "Hello,\n\nGlue Job is completed successfully."
      },
      "End": true
    }
  }
}
EOF
}



### AWS REDSHIFT CLUSTER 

# resource "aws_redshift_cluster" "redshiftCluster1" {
#   cluster_identifier = "tf-redshift-cluster"
#   database_name      = "dev"
#   master_username    = "nikhil"
#   master_password    = "#Nikhil33"
#   node_type          = "dc2.large"
#   cluster_type       = "single-node"
# }

# resource "aws_redshift_cluster_iam_roles" "redshiftCluster1" {
#   cluster_identifier = aws_redshift_cluster.redshiftCluster1.cluster_identifier
#   iam_role_arns      = ["arn:aws:iam::684710758112:role/LabRole"]
# }


