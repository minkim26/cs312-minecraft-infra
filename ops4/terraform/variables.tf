variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for all resources. Must match the region of your ECR repository and S3 bucket."
}

variable "instance_type" {
  type        = string
  default     = "t3.medium"
  description = "EC2 instance type. t3.medium (2 vCPU / 4 GB) is the minimum viable size for k3s plus the Minecraft JVM."
}

variable "ami_id" {
  type        = string
  description = "Ubuntu Server 24.04 LTS AMI ID for us-east-1. Look up in EC2 Launch Wizard — AMI IDs change over time."
}

variable "key_name" {
  type        = string
  description = "Name of the pre-existing EC2 key pair. Ansible uses this to SSH into the instance."
}

variable "ssh_cidr" {
  type        = string
  description = "Your public IP in CIDR notation (e.g. 1.2.3.4/32). Restricts SSH to your machine only."
}

variable "volume_size_gb" {
  type        = number
  default     = 30
  description = "Root EBS volume size in GB. 30 GB covers Ubuntu, containerd image cache, and world data."
}

variable "ecr_repo_name" {
  type        = string
  default     = "cs312-minecraft"
  description = "ECR repository name. Reused unchanged from Ops 3."
}

variable "s3_bucket_name" {
  type        = string
  default     = "cs312-minsu-kim-mc-backups"
  description = "Pre-existing S3 bucket for world backups. Reused unchanged from Ops 3."
}
