
output "instance_sg_arn" {
  description = "Security Group ARN attached to instance launch config and thereby the nexus EC2 instance"
  value       = aws_security_group.elb.arn
}

output "lb_arn" {
  description = "ARN of the ELB for Nexus access"
  value       = aws_lb.this.arn
}

output "lb_dns_name" {
  description = "DNS Name of the ELB for Nexus access"
  value       = aws_lb.this.dns_name
}

output "lb_sg_arn" {
  description = "Security Group ARN attached to ELB"
  value       = aws_security_group.elb.arn
}

output "lb_zone_id" {
  description = "Route53 Zone ID of the ELB for Nexus access"
  value       = aws_lb.this.zone_id
}

output "role_arn" {
  description = "IAM Role ARN of Nexus instance"
  value       = aws_iam_role.this.arn
}
