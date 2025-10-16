Multi Region Disaster Recovery

This project deploys a multi-region, highly available web application with disaster recovery capabilities on AWS using Terraform. The application is a Flask-based web app (app.py) that interacts with an Aurora MySQL Global Database (appdb) for data persistence. The infrastructure spans two AWS regions (us-east-1 as primary, us-west-2 as secondary) with failover routing via Route 53, ensuring continuity if the primary region fails. The setup includes VPCs, ALBs, ASGs, Aurora clusters, Route 53, S3 for state and app files, and CloudWatch/SNS for monitoring.

Architecture


<img width="481" height="376" alt="image" src="https://github.com/user-attachments/assets/b5f68a4e-40f3-42fa-a183-b6ac8a4d5120" />
