# terraform-aws-nexus [![](https://github.com/rhythmictech/terraform-aws-nexus/workflows/pre-commit-check/badge.svg)](https://github.com/rhythmictech/terraform-aws-nexus/actions) <a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=RhythmicTech" alt="follow on Twitter"></a>

Create a Nexus OSS or Nexus Pro instance. This does some neat things:

* `sonatype-work` directory is managed by EFS with optional backups using AWS Backup
* everything runs in an ASG (though HA isn't supported.. yet..) so if something happens to the instance, it'll come back up automatically.
* updates are done by upgrading your AMI and replacing the launch config
* automatically manages licensing pro installs and enabling the modules

## Requirements

This expects an instance that has Nexus pre-installed using the Rhythmic [ansible-role-nexus](https://github.com/rhythmictech/ansible-role-nexus) ansible module. The easiest way to get one is to use Packer.

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
| terraform | >= 0.12.25 |

## Providers

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ami\_id | AMI to build on \(must have `ansible-role-nexus` module installed\) | string | n/a | yes |
| asg\_additional\_iam\_policies | Additional IAM policies to attach to the  ASG instance profile | list(string) | `[]` | no |
| asg\_additional\_security\_groups | Additional security group IDs to attach to ASG instances | list(string) | `[]` | no |
| asg\_desired\_capacity | The number of Amazon EC2 instances that should be running in the group. | number | `"1"` | no |
| asg\_instance\_type | Instance type for scim app | string | `"t3a.micro"` | no |
| asg\_key\_name | Optional keypair to associate with instances | string | `"null"` | no |
| asg\_max\_size | Maximum number of instances in the autoscaling group | number | `"2"` | no |
| asg\_min\_size | Minimum number of instances in the autoscaling group | number | `"1"` | no |
| asg\_subnets | Subnets to associate ASG instances with \(specify 1 or more\) | list(string) | n/a | yes |
| efs\_additional\_allowed\_security\_groups | Additional security group IDs to attach to the EFS export | list(string) | `[]` | no |
| efs\_backup\_retain\_days | Days to retain EFS backups for \(only used if `enable\_efs\_backups=true`\) | bool | `"30"` | no |
| efs\_backup\_schedule | AWS Backup cron schedule \(only used if `enable\_efs\_backups=true`\) | string | `"cron(0 5 ? * * *)"` | no |
| efs\_backup\_vault\_name | AWS Backup vault name \(only used if `enable\_efs\_backups=true`\) | string | `"nexus-efs-vault"` | no |
| efs\_subnets | Subnets to create EFS mountpoints in | list(string) | n/a | yes |
| elb\_certificate | ARN of certificate to associate with ELB | string | n/a | yes |
| elb\_internal | Create as an internal or internet-facing ELB | bool | `"true"` | no |
| elb\_subnets | Subnets to associate ELB to | list(string) | n/a | yes |
| enable\_efs\_backups | Enable EFS backups using AWS Backup \(recommended if you aren't going to back up EFS some other way\) | bool | `"false"` | no |
| license\_secret | S3 key including any prefix that has the Nexus Pro license \(omit for OSS installs\) | string | `""` | no |
| name | Moniker to apply to all resources in the module | string | n/a | yes |
| tags | User-Defined tags | map(string) | `{}` | no |
| vpc\_id | VPC to create associated resources in | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| lb\_arn | ARN of the ELB for Nexus access |
| lb\_dns\_name | DNS Name of the ELB for Nexus access |
| lb\_zone\_id | Route53 Zone ID of the ELB for Nexus access |
| role\_arn | IAM Role ARN of Nexus instance |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
