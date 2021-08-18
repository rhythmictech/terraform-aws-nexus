# terraform-aws-nexus

[![tflint](https://github.com/rhythmictech/terraform-aws-nexus/workflows/tflint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-nexus/actions?query=workflow%3Atflint+event%3Apush+branch%3Amaster)
[![tfsec](https://github.com/rhythmictech/terraform-aws-nexus/workflows/tfsec/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-nexus/actions?query=workflow%3Atfsec+event%3Apush+branch%3Amaster)
[![yamllint](https://github.com/rhythmictech/terraform-aws-nexus/workflows/yamllint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-nexus/actions?query=workflow%3Ayamllint+event%3Apush+branch%3Amaster)
[![misspell](https://github.com/rhythmictech/terraform-aws-nexus/workflows/misspell/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-nexus/actions?query=workflow%3Amisspell+event%3Apush+branch%3Amaster)
[![pre-commit-check](https://github.com/rhythmictech/terraform-aws-nexus/workflows/pre-commit-check/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-nexus/actions?query=workflow%3Apre-commit-check+event%3Apush+branch%3Amaster)
<a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=twitter" alt="follow on Twitter"></a>

Create a Nexus OSS or Nexus Pro instance. This does some neat things:


* `sonatype-work` directory is managed by EFS with optional backups using AWS Backup
* everything runs in an ASG (though HA isn't supported.. yet..) so if something happens to the instance, it'll come back up automatically.
* updates are done by upgrading your AMI and replacing the launch config
* automatically manages licensing pro installs and enabling the modules

## Requirements

This expects an instance that has Nexus pre-installed using the Rhythmic [ansible-role-nexus](https://github.com/rhythmictech/ansible-role-nexus3) ansible module. The easiest way to get one is to use Packer.

## License File (Pro only)
To use Pro, you need to save your license file in AWS Secrets Manager. Something like this would work:

```
aws --region us-east-1 secretsmanager create-secret --secret-id nexus-license --secret-binary=file:///tmp/nexus.lic
```

_Tip: when you renew your license, update the secret and kill the instance. It will automatically be updated._

## Example
Here's what using the module will look like
```
module "example" {
  source = "git::https://github.com/rhythmictech/terraform-aws-nexus.git"

  name                           = "nexus"
  ami_id                         = "ami-12345678912"
  asg_subnets                    = ["subnet-123456789012", "subnet-123456789013"]
  efs_subnets                    = ["subnet-123456789012", "subnet-123456789013"]
  elb_certificate                = "arn:aws:acm:us-east-1:12345678912:certificate/090c1a21-f053-4aac-8b92-2c963c3c0660"
  elb_subnets                    = ["subnet-123456789012", "subnet-123456789013"]
  vpc_id                         = "vpc-123456789012"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.45.0, < 4.0.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~>2.1.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.45.0, < 4.0.0 |
| <a name="provider_template"></a> [template](#provider\_template) | ~>2.1.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_backup_plan.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_selection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_efs_file_system.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.additional_this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.additional_this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.additional_allow_inbound_http_from_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.additional_elb_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.additional_elb_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_inbound_http_from_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_iam_policy_document.assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_cloudinit_config.this](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI to build on (must have `ansible-role-nexus` module installed) | `string` | n/a | yes |
| <a name="input_asg_subnets"></a> [asg\_subnets](#input\_asg\_subnets) | Subnets to associate ASG instances with (specify 1 or more) | `list(string)` | n/a | yes |
| <a name="input_efs_subnets"></a> [efs\_subnets](#input\_efs\_subnets) | Subnets to create EFS mountpoints in | `list(string)` | n/a | yes |
| <a name="input_elb_certificate"></a> [elb\_certificate](#input\_elb\_certificate) | ARN of certificate to associate with ELB | `string` | n/a | yes |
| <a name="input_elb_subnets"></a> [elb\_subnets](#input\_elb\_subnets) | Subnets to associate ELB to | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Moniker to apply to all resources in the module | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC to create associated resources in | `string` | n/a | yes |
| <a name="input_access_logs_bucket"></a> [access\_logs\_bucket](#input\_access\_logs\_bucket) | The name of the bucket to store LB access logs in. Required if `access_logs_enabled` is `true` | `string` | `null` | no |
| <a name="input_access_logs_enabled"></a> [access\_logs\_enabled](#input\_access\_logs\_enabled) | Whether to enable LB access logging | `bool` | `false` | no |
| <a name="input_access_logs_prefix"></a> [access\_logs\_prefix](#input\_access\_logs\_prefix) | The path prefix to apply to the LB access logs. | `string` | `null` | no |
| <a name="input_additional_ports"></a> [additional\_ports](#input\_additional\_ports) | Additional ports (besides 80/443 for the UI) to open on the nexus instance and create listeners for | `list(number)` | `[]` | no |
| <a name="input_additional_ports_protocol"></a> [additional\_ports\_protocol](#input\_additional\_ports\_protocol) | Protocol [HTTP, HTTPS] to use for the additional ports | `string` | `"HTTPS"` | no |
| <a name="input_asg_additional_iam_policies"></a> [asg\_additional\_iam\_policies](#input\_asg\_additional\_iam\_policies) | Additional IAM policies to attach to the  ASG instance profile | `list(string)` | `[]` | no |
| <a name="input_asg_additional_security_groups"></a> [asg\_additional\_security\_groups](#input\_asg\_additional\_security\_groups) | Additional security group IDs to attach to ASG instances | `list(string)` | `[]` | no |
| <a name="input_asg_additional_target_group_arns"></a> [asg\_additional\_target\_group\_arns](#input\_asg\_additional\_target\_group\_arns) | ARNs of additional target groups to attach to the ASG | `list(string)` | `[]` | no |
| <a name="input_asg_additional_user_data"></a> [asg\_additional\_user\_data](#input\_asg\_additional\_user\_data) | Additional User Data to attach to the launch template | `string` | `""` | no |
| <a name="input_asg_desired_capacity"></a> [asg\_desired\_capacity](#input\_asg\_desired\_capacity) | The number of Amazon EC2 instances that should be running in the group. | `number` | `1` | no |
| <a name="input_asg_instance_type"></a> [asg\_instance\_type](#input\_asg\_instance\_type) | Instance type for scim app | `string` | `"t3a.micro"` | no |
| <a name="input_asg_key_name"></a> [asg\_key\_name](#input\_asg\_key\_name) | Optional keypair to associate with instances | `string` | `null` | no |
| <a name="input_asg_max_size"></a> [asg\_max\_size](#input\_asg\_max\_size) | Maximum number of instances in the autoscaling group | `number` | `2` | no |
| <a name="input_asg_min_size"></a> [asg\_min\_size](#input\_asg\_min\_size) | Minimum number of instances in the autoscaling group | `number` | `1` | no |
| <a name="input_asg_root_volume_type"></a> [asg\_root\_volume\_type](#input\_asg\_root\_volume\_type) | This should match the root volume type of the AMI | `string` | `"gp3"` | no |
| <a name="input_efs_additional_allowed_security_groups"></a> [efs\_additional\_allowed\_security\_groups](#input\_efs\_additional\_allowed\_security\_groups) | Additional security group IDs to attach to the EFS export | `list(string)` | `[]` | no |
| <a name="input_efs_backup_retain_days"></a> [efs\_backup\_retain\_days](#input\_efs\_backup\_retain\_days) | Days to retain EFS backups for (only used if `enable_efs_backups=true`) | `number` | `30` | no |
| <a name="input_efs_backup_schedule"></a> [efs\_backup\_schedule](#input\_efs\_backup\_schedule) | AWS Backup cron schedule (only used if `enable_efs_backups=true`) | `string` | `"cron(0 5 ? * * *)"` | no |
| <a name="input_efs_backup_vault_name"></a> [efs\_backup\_vault\_name](#input\_efs\_backup\_vault\_name) | AWS Backup vault name (only used if `enable_efs_backups=true`) | `string` | `"nexus-efs-vault"` | no |
| <a name="input_elb_additional_sg_tags"></a> [elb\_additional\_sg\_tags](#input\_elb\_additional\_sg\_tags) | Additional tags to apply to the ELB security group. Useful if you use an external process to manage ingress rules. | `map(string)` | `{}` | no |
| <a name="input_elb_allowed_cidr_blocks"></a> [elb\_allowed\_cidr\_blocks](#input\_elb\_allowed\_cidr\_blocks) | List of allowed CIDR blocks. If `[]` is specified, no inbound ingress rules will be created | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_elb_internal"></a> [elb\_internal](#input\_elb\_internal) | Create as an internal or internet-facing ELB | `bool` | `true` | no |
| <a name="input_enable_efs_backups"></a> [enable\_efs\_backups](#input\_enable\_efs\_backups) | Enable EFS backups using AWS Backup (recommended if you aren't going to back up EFS some other way) | `bool` | `false` | no |
| <a name="input_license_secret"></a> [license\_secret](#input\_license\_secret) | S3 key including any prefix that has the Nexus Pro license (omit for OSS installs) | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | User-Defined tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_sg_arn"></a> [instance\_sg\_arn](#output\_instance\_sg\_arn) | Security Group ARN attached to instance launch config and thereby the nexus EC2 instance |
| <a name="output_lb_arn"></a> [lb\_arn](#output\_lb\_arn) | ARN of the ELB for Nexus access |
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | DNS Name of the ELB for Nexus access |
| <a name="output_lb_sg_arn"></a> [lb\_sg\_arn](#output\_lb\_sg\_arn) | Security Group ARN attached to ELB |
| <a name="output_lb_zone_id"></a> [lb\_zone\_id](#output\_lb\_zone\_id) | Route53 Zone ID of the ELB for Nexus access |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | IAM Role ARN of Nexus instance |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
