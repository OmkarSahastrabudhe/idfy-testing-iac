# ==============================================================================
# 1. PACKER BLOCK (AWS Plugin Download)
# ==============================================================================
packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}




locals {
  # Default UTC time mein 5 Hours 30 Minutes add karke IST banaya
  ist_raw_time = timeadd(timestamp(), "5h30m")

  # AMI Name ke liye format (Spaces/Colons allowed nahi hote): e.g., 20261101-222600-IST
  ist_timestamp = "${formatdate("YYYYMMDD-hhmmss", local.ist_raw_time)}-IST"

  # AWS Tag ke liye readable format: e.g., 01-Nov-2026 10:26 PM IST
  ist_readable = "${formatdate("DD-MMM-YYYY hh:mm AA", local.ist_raw_time)} IST"
}


source "amazon-ebs" "ubuntu_nginx" {
  ami_name      = "${var.ami_prefix}-${local.ist_timestamp}"
  ami_description = "Custom Ubuntu 24.04 AMI with Nginx pre-installed via Packer"
  instance_type = var.instance_type
  region        = var.aws_region
  ssh_username  = "ubuntu"

  # Base Image Config: Automatically fetch latest official Ubuntu 24.04 LTS AMI
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] # Canonical (Ubuntu) Official AWS Account ID
  }

  # Tags jo final AMI par lagenge (Terraform/Terragrunt isi se filter karega!)
  tags = {
    Name      = "${var.ami_prefix}-${local.ist_timestamp}"
    Role      = "frontend-nginx"
    Builder   = "Packer"
    OS        = "Ubuntu-24.04"
    CreatedAt = local.ist_readable
  }

  # Temporary EC2 instance ke upar naam (Build chalte waqt AWS Console mein dikhega)
  run_tags = {
    Name = "Packer-Temporary-Builder-Nginx"
  }
}

# ==============================================================================
# 5. BUILD BLOCK (Connects Source Image with Shell Script)
# ==============================================================================
build {
  name    = "nginx-golden-ami-build"
  sources = ["source.amazon-ebs.ubuntu_nginx"]

  # Local bash script ko remote temporary EC2 par upload karke execute karega
  provisioner "shell" {
    script = "${path.root}/scripts/install_nginx.sh"
  }
}