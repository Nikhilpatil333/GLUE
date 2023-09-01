import boto3

def lambda_handler(event, context):
    glue_client = boto3.client('glue')

    # Check if the CloudWatch event indicates a Glue job creation event
    if event['detail']['eventName'] == 'JOB_CREATED':
        job_name = event['detail']['requestParameters']['name']

        # Start the Glue job
        response = glue_client.start_job_run(JobName=job_name)
        
        # You can optionally log the response for debugging
        print(response)
    
    return {
        'statusCode': 200,
        'body': 'Lambda function executed successfully'
    }
