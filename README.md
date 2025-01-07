# MISP on AWS

This project deploys a **MISP (Malware Information Sharing Platform)** application on AWS using infrastructure as code (Terraform), Docker, and ECS. The deployment is scalable, secure, and leverages AWS services like RDS, ElastiCache, EFS, and ECS for efficient cloud-native implementation.

---

## **Features**

- **Fully Containerized**: Deploy MISP using Docker containers.
- **Scalable Infrastructure**: Leverage AWS ECS and Fargate for automatic scaling.
- **Database and Cache Integration**:
  - MySQL RDS as the database backend.
  - ElastiCache (Redis) for in-memory data storage.
- **Persistent Storage**: Elastic File System (EFS) for persistent container storage.
- **Secure Networking**: Isolated VPC with subnets, security groups, and HTTPS.
- **CI/CD Ready**: GitHub Actions pipeline for automated deployment (optional).

---

## **Project Structure**

```plaintext
misp-on-aws/
├── terraform/                     # Main Terraform configuration
│   ├── main.tf                    # Orchestrates modules and resources
│   ├── variables.tf               # Defines input variables
│   ├── outputs.tf                 # Defines Terraform outputs
│   ├── provider.tf                # AWS provider configuration
│   └── modules/                   # Terraform reusable modules
│       ├── vpc/                   # VPC module
│       ├── ecs/                   # ECS module
│       ├── rds/                   # RDS module
│       ├── redis/                 # Redis module
│       └── efs/                   # EFS module
├── docker/                        # Docker-related files
│   ├── Dockerfile                 # Dockerfile for MISP container
│   ├── misp.env                   # Optional: Environment variables for MISP
│   └── entrypoint.sh              # Optional: Custom entrypoint script
├── ecs/                           # ECS-related files
│   ├── task-definition.json       # ECS task definition for MISP
│   └── service-definition.json    # ECS service definition (optional)
├── .github/workflows/             # CI/CD pipeline
│   └── deploy-misp.yml            # GitHub Actions workflow for ECS deployment
├── terraform.tfvars               # Terraform input variables
├── .gitignore                     # Prevent sensitive files from being committed
└── README.md                      # Project overview (this file)
```

---

## **Prerequisites**

1. **AWS Account** with permissions to create resources.
2. **Terraform** installed on your local machine.
3. **Docker** installed and configured.
4. **AWS CLI** installed and configured with credentials.
5. **GitHub Repository** (already set up: [MISP-on-AWS](https://github.com/Unnavasriteja/MISP-on-AWS.git)).

---

## **Setup and Deployment**

### **Understanding Terraform**
Terraform is an Infrastructure as Code (IaC) tool that allows you to define and manage your infrastructure using code. For this project, Terraform is used to provision all necessary AWS resources for deploying MISP, such as:

1. **VPC**:
   - A Virtual Private Cloud (VPC) with public and private subnets for secure networking.
   - An Internet Gateway for external access and route tables for subnet communication.

2. **ECS**:
   - An Amazon ECS cluster to run Docker containers.
   - Associated security groups to control access.

3. **RDS**:
   - A MySQL database instance for MISP persistence.
   - Subnet groups to ensure high availability.

4. **Redis (ElastiCache)**:
   - An in-memory data store to improve performance.
   - Subnet groups for isolated and secure caching.

5. **EFS**:
   - Elastic File System (EFS) for shared and persistent storage for ECS tasks.

### Benefits of Terraform:
- **Consistency**: Define your entire infrastructure in reusable modules.
- **Version Control**: Manage changes to your infrastructure using Git.
- **Automation**: Automate resource creation, updates, and deletions.
- **Multi-Cloud Support**: While this project uses AWS, Terraform can also manage resources on other platforms like Azure and GCP.

---


### **1. Configure Terraform**

#### **Example: ****`terraform.tfvars`**** File**

Create a mention file in the root directory with the following:

```hcl
region = "us-east-1"
vpc_cidr = "10.0.0.0/16"
public_cidr = "10.0.1.0/24"
private_cidr = "10.0.2.0/24"
availability_zone = "us-east-1a"

cluster_name = "misp-cluster"

db_name = "mispdb"
db_username = "admin"
db_password = "YourStrongPassword123" # Replace this with a secure password

redis_cluster_id = "misp-redis"
# redis_password = "YourRedisPassword123" # Uncomment if Redis AUTH is enabled

efs_creation_token = "misp-efs"
```

Add `terraform.tfvars` to five  to ensure it’s not committed.

#### **Initialize and Apply Terraform**

Run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

This will provision all the required AWS resources.

---

### **2. Build and Push Docker Image**

#### **Build the Docker Image**

Run the following command in the `docker/` directory:

```bash
docker build -t misp:latest .
```

#### **Push to Amazon ECR**

1. Log in to ECR:
   ```bash
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <your-ecr-repository-uri>
   ```
2. Push the image:
   ```bash
   docker tag misp:latest <your-ecr-repository-uri>:latest
   docker push <your-ecr-repository-uri>:latest
   ```

---

### **3. Deploy ECS Service**

#### **Register Task Definition**

Update `ecs/task-definition.json` with actual values (e.g., RDS and Redis endpoints). Then register it using AWS CLI:

```bash
aws ecs register-task-definition --cli-input-json file://ecs/task-definition.json
```

#### **Create ECS Service**

Use the AWS CLI or Management Console to create an ECS service linked to the task definition.

---

### **4. Optional: Enable CI/CD**

To enable CI/CD using GitHub Actions, uncomment and use the workflow file located at `.github/workflows/deploy-misp.yml`.

---

## **Architecture Diagram**

Need to be added

---

## **Verifying Deployment**

### Locally:

1. **Docker Container**:

   - Run `docker ps` to ensure the MISP container is running locally.
   - Access the application at `http://localhost` (or the port you specified).

2. **Terraform Outputs**:

   - Check Terraform outputs to verify endpoints for RDS, Redis, and ECS.
   - Example:
     ```bash
     terraform output
     ```

### On Cloud:

1. **ECS Tasks**:

   - Go to the AWS Management Console → ECS → Clusters → `misp-cluster` → Tasks.
   - Ensure the task status is `RUNNING`.

2. **Application Load Balancer**:

   - Verify the ALB DNS name in the AWS Console.
   - Open the URL in your browser to check if MISP is accessible.

3. **Logs**:

   - View ECS task logs in CloudWatch for errors or successful application startup.

### Destroying Resources to Save Costs

Once you're done testing or deploying:

1. Destroy Terraform resources:

   ```bash
   terraform destroy
   ```

   This removes all AWS resources created by Terraform.

2. Clean up Docker resources:

   ```bash
   docker system prune -a
   ```

---

## **Troubleshooting**

### Common Issues:

1. **Terraform Errors**:

   - Ensure AWS credentials are correctly configured.
   - Check IAM permissions.

2. **ECS Task Failing**:

   - Verify Docker image configuration.
   - Check logs in CloudWatch for debugging.

3. **ALB Health Check Failing**:

   - Ensure correct target group configuration.
   - Verify security group rules.

---

## **Future Enhancements**

- **Improved Security**: Integrate AWS Secrets Manager to securely manage sensitive environment variables.
- **Enhanced Monitoring**: Add CloudWatch alarms for ECS task failures and resource utilization.
- **Auto-Scaling**: Configure ECS and RDS for automatic scaling based on user demand.
- **Multi-Region Deployment**: Extend the architecture for disaster recovery and high availability.
- **API Gateway Integration**: Use AWS API Gateway to manage and secure access to MISP APIs.

---

## **Useful Resources**

- [MISP Documentation](https://www.misp-project.org/documentation/)
- [Terraform Documentation](https://www.terraform.io/docs/)
- [AWS ECS Documentation](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html)
- [Docker Documentation](https://docs.docker.com/)

---

## **Acknowledgments**

- Thanks to the MISP community for maintaining the open-source platform.
- Inspired by AWS best practices for containerized workloads.

---

## **Deployment Time Estimate**

- **Terraform Apply**: Approximately 5-10 minutes.
- **Docker Build and Push**: 3-5 minutes (depending on network speed).
- **ECS Task Deployment**: 5-7 minutes.

---

## **Contributing**

Feel free to fork this repository, submit issues, or create pull requests to enhance this project.

---

## **License**

This project is licensed under the MIT License. See the `LICENSE` file for details.

