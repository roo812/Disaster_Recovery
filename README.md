Multi Region Disaster Recovery<img width="468" height="29" alt="image" src="https://github.com/user-attachments/assets/78ac646b-6033-49ed-a9d9-3d1673f60758" />


This project deploys a multi-region, highly available web application with disaster recovery capabilities on AWS using Terraform. The application is a Flask-based web app (app.py) that interacts with an Aurora MySQL Global Database (appdb) for data persistence. The infrastructure spans two AWS regions (us-east-1 as primary, us-west-2 as secondary) with failover routing via Route 53, ensuring continuity if the primary region fails. The setup includes VPCs, ALBs, ASGs, Aurora clusters, Route 53, S3 for state and app files, and CloudWatch/SNS for monitoring.


