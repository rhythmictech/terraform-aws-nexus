# terraform-aws-nexus [![](https://github.com/rhythmictech/terraform-aws-nexus/workflows/pre-commit-check/badge.svg)](https://github.com/rhythmictech/terraform-aws-nexus/actions) <a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=RhythmicTech" alt="follow on Twitter"></a>

Create a Nexus OSS or Nexus Pro instance. Uses some neat things:

* `sonatype-work` directory is managed by EFS with optional backups using AWS Backup
* everything runs in an ASG (though HA isn't supported.. yet..) so if something happens to the instance, it'll come back up automatically.
* updates are done by upgrading your AMI
* automatically manages licensing pro

## Pre-requisites

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

No requirements.

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Moniker to apply to all resources in the module | `string` | n/a | yes |
| tags | User-Defined tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| tags\_module | Tags Module in it's entirety |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## The Giants underneath this module
- pre-commit.com/
- terraform.io/
- github.com/tfutils/tfenv
- github.com/segmentio/terraform-docs
