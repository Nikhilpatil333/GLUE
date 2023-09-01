import boto3
import json

def lambda_handler(event, context):
    # Extract relevant information from the CloudWatch event
    job_name = event['detail']['jobName']
    job_run_id = event['detail']['jobRunId']
    
    # Create a Glue client
    glue = boto3.client('glue')
    
    try:
        # Start the Glue job run
        response = glue.start_job_run(JobName=job_name, JobRunId=job_run_id)
        
        # Return the response or success message
        return {
            "statusCode": 200,
            "body": f"Glue job run started: {response['JobRunId']}"
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Error starting Glue job run: {str(e)}"
        }