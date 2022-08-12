########################################
# General Vars
########################################

variable "name" {
  description = "Moniker to apply to all resources in the module"
  type        = string
}

variable "tags" {
  default     = {}
  description = "User-Defined tags"
  type        = map(string)
}

########################################
# Nexus Vars
########################################

variable "license_secret" {
  default     = ""
  description = "S3 key including any prefix that has the Nexus Pro license (omit for OSS installs)"
  type        = string
}

########################################
# ASG Vars
########################################

variable "additional_ports" {
  default     = []
  description = "Additional ports (besides 80/443 for the UI) to open on the nexus instance and create listeners for"
  type        = list(number)
}

variable "additional_ports_protocol" {
  default     = "HTTPS"
  description = "Protocol [HTTP, HTTPS] to use for the additional ports"
  type        = string
}


variable "ami_id" {
  description = "AMI to build on (must have `ansible-role-nexus` module installed)"
  type        = string
}

variable "asg_additional_iam_policies" {
  default     = []
  description = "Additional IAM policies to attach to the  ASG instance profile"
  type        = list(string)
}

variable "asg_additional_security_groups" {
  default     = []
  description = "Additional security group IDs to attach to ASG instances"
  type        = list(string)
}

variable "asg_additional_target_group_arns" {
  default     = []
  description = "ARNs of additional target groups to attach to the ASG"
  type        = list(string)
}

variable "asg_additional_user_data" {
  default     = ""
  description = "Additional User Data to attach to the launch template"
  type        = string
}

variable "asg_desired_capacity" {
  default     = 1
  description = "The number of Amazon EC2 instances that should be running in the group."
  type        = number
}

variable "asg_instance_type" {
  default     = "t3a.micro"
  description = "Instance type for scim app"
  type        = string
}

variable "asg_key_name" {
  default     = null
  description = "Optional keypair to associate with instances"
  type        = string
}

variable "asg_max_size" {
  default     = 2
  description = "Maximum number of instances in the autoscaling group"
  type        = number
}

variable "asg_min_size" {
  default     = 1
  description = "Minimum number of instances in the autoscaling group"
  type        = number
}

variable "asg_subnets" {
  description = "Subnets to associate ASG instances with (specify 1 or more)"
  type        = list(string)
}

########################################
# Networking Vars
########################################

variable "access_logs_bucket" {
  default     = null
  description = "The name of the bucket to store LB access logs in. Required if `access_logs_enabled` is `true`"
  type        = string
}

variable "access_logs_enabled" {
  default     = false
  description = "Whether to enable LB access logging"
  type        = bool
}

variable "access_logs_prefix" {
  default     = null
  description = "The path prefix to apply to the LB access logs."
  type        = string
}

variable "elb_additional_sg_tags" {
  default     = {}
  description = "Additional tags to apply to the ELB security group. Useful if you use an external process to manage ingress rules."
  type        = map(string)
}

variable "elb_allowed_cidr_blocks" {
  default     = ["0.0.0.0/0"]
  description = "List of allowed CIDR blocks. If `[]` is specified, no inbound ingress rules will be created"
  type        = list(string)
}

variable "elb_certificate" {
  description = "ARN of certificate to associate with ELB"
  type        = string
}

variable "elb_internal" {
  default     = true
  description = "Create as an internal or internet-facing ELB"
  type        = bool
}

variable "elb_subnets" {
  description = "Subnets to associate ELB to"
  type        = list(string)
}


variable "vpc_id" {
  description = "VPC to create associated resources in"
  type        = string
}

########################################
# EFS Vars
########################################

variable "efs_additional_allowed_security_groups" {
  default     = []
  description = "Additional security group IDs to attach to the EFS export"
  type        = list(string)
}

variable "efs_backup_retain_days" {
  default     = 30
  description = "Days to retain EFS backups for (only used if `enable_efs_backups=true`)"
  type        = number
}

variable "efs_backup_schedule" {
  default     = "cron(0 5 ? * * *)"
  description = "AWS Backup cron schedule (only used if `enable_efs_backups=true`)"
  type        = string
}

variable "efs_backup_vault_name" {
  default     = "nexus-efs-vault"
  description = "AWS Backup vault name (only used if `enable_efs_backups=true`)"
  type        = string
}

variable "efs_subnets" {
  description = "Subnets to create EFS mountpoints in"
  type        = list(string)
}

variable "enable_efs_backups" {
  default     = false
  description = "Enable EFS backups using AWS Backup (recommended if you aren't going to back up EFS some other way)"
  type        = bool
}

########################################
# RootVolume Vars
########################################

variable "root_volume_encryption" {
  default     = true
  description = "Encrypted root volume"
  type        = bool
}

variable "root_volume_size" {
  default     = null
  description = "Size of the root volume"
  type        = number
}

variable "root_volume_type" {
  default     = "gp2"
  description = "Size of the root volume"
  type        = string
}
