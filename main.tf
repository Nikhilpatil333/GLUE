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

# 
resource "aws_glue_job" "glue_job" {
  name = "group2"
  role_arn = "arn:aws:iam::684710758112:role/LabRole"
  description = "This is script to convert dataset"
  max_retries = "1"
  timeout = 2880

  max_capacity             = 5    # Set the maximum number of worker nodes
  number_of_workers        = 5    # Set the initial number of worker nodes
  worker_type              = "G.1X"  # Specify the worker type

  command {
    script_location = "s3://terraform-nikhil-prac/test.py"
    python_version = "3"
  }
  execution_property {
    max_concurrent_runs = 2
  }
  glue_version = "4.0"

}
  resource "aws_glue_trigger" "glue_trigger" {
  name = "group2_trigger"
  type = "EVENT"
  event_pattern {
    
    detail-type = "Glue Job State Change"
  }
  start = true
  
}





