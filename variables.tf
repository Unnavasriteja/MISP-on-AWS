variable "region" {
  description = "AWS region for resource deployment"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_cidr" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "private_cidr" {
  description = "CIDR block for the private subnet"
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Availability zone for resources"
  default     = "us-east-1a"
}

variable "cluster_name" {
  description = "Name of the ECS Cluster"
  default     = "misp-cluster"
}

variable "db_name" {
  description = "Name of the RDS database"
  default     = "mispdb"
}

variable "db_username" {
  description = "Username for the RDS database"
  default     = "admin"
}

variable "db_password" {
  description = "Password for the RDS database"
}

variable "redis_cluster_id" {
  description = "ID of the Redis cluster"
  default     = "misp-redis"
}

variable "efs_creation_token" {
  description = "Token to ensure idempotent creation of the EFS"
  default     = "misp-efs"
}
