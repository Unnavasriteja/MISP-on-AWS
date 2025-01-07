output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = module.vpc.private_subnet_id
}

output "ecs_cluster_id" {
  description = "The ID of the ECS Cluster"
  value       = module.ecs.cluster_id
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = module.rds.endpoint
}

output "redis_endpoint" {
  description = "The endpoint of the Redis cluster"
  value       = module.redis.endpoint
}

output "efs_id" {
  description = "The ID of the EFS file system"
  value       = module.efs.file_system_id
}
