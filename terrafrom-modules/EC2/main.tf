# terraform-modules/ec2/main.tf

# 1. DYNAMIC AMI LOOKUP (Packer ki banayi image AWS se fetch karega)
data "aws_ami" "packer_ami" {
  most_recent = true
  owners      = var.ami_owners

  dynamic "filter" {
    for_each = var.ami_filters
    content {
      name   = filter.key
      values = filter.value
    }
  }
}

# 2. KEYLESS EC2 INSTANCE (SSM Enabled + Local User Data File Function)
resource "aws_instance" "this" {
  ami                    = data.aws_ami.packer_ami.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

  # NO key_name HERE! Login strictly via AWS SSM Agent using IAM Instance Profile
  iam_instance_profile   = var.iam_instance_profile

  # ============================================================================
  # USER DATA ENGINE: file() function reads the script from your local machine!
  # ============================================================================
  user_data                   = var.user_data_script_path != null ? file(var.user_data_script_path) : null
  user_data_replace_on_change = true

  # Security Best Practice: Enforce IMDSv2 (SSM Agent fully supports IMDSv2)
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    encrypted             = true
    delete_on_termination = true
  }

  tags = merge(
    {
      Name        = var.instance_name
      AmiIdUsed   = data.aws_ami.packer_ami.id
      AmiNameUsed = data.aws_ami.packer_ami.name
      AccessMode  = "SSM-Session-Manager-Only"
      ManagedBy   = "Terraform-Terragrunt"
    },
    var.extra_tags
  )
}