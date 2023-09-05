import json
import subprocess
import smtplib
from email.mime.text import MIMEText

# Run Terraform command to get the outputs
terraform_command = "terraform output -json"
outputs_json = subprocess.check_output(terraform_command, shell=True).decode('utf-8')
outputs = json.loads(outputs_json)

# Email configuration
email_subject = "Redshift Cluster Information"
email_body = f"Redshift Cluster Endpoint: {outputs['redshift_cluster_endpoint']}\n"

sender_email = "tejasjoshi758@gmail.com"
sender_password = "Tejas@758"
receiver_email = "ingoleajit1997@gmail.com"

# Send the email
msg = MIMEText(email_body)
msg["Subject"] = email_subject
msg["From"] = sender_email
msg["To"] = receiver_email

try:
    server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
    server.login(sender_email, sender_password)
    server.sendmail(sender_email, receiver_email, msg.as_string())
    server.quit()
    print("Email sent successfully!")
except Exception as e:
    print("Error sending email:", str(e))