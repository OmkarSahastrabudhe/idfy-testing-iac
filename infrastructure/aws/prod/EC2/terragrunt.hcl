# terragrunt-live/prod/ec2/terragrunt.hcl

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../terraform-modules/EC2/"
}

# ==============================================================================
# 1. DEPENDENCY ON IAM MODULE (Fetches Instance Profile Name automatically)
# ==============================================================================
dependency "iam" {
  config_path = "../IAM"

  # Mock outputs allow 'terragrunt run-all plan' to work even BEFORE IAM is deployed!
  mock_outputs = {
    instance_profile_name = "mock-iam-instance-profile"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

# Optional: Ensure S3 is also created before EC2 boots up
dependency "s3" {
  config_path  = "../S3"
  skip_outputs = true
}

# ==============================================================================
# 2. INPUTS TO EC2 MODULE
# ==============================================================================
inputs = {
  instance_name = "prod-nginx-web-server"
  instance_type = "t3.micro"

  # APNA REAL SUBNET AUR SECURITY GROUP ID YAHAN DAALNA:
  subnet_id              = "subnet-0bcf0058c574ac764" # <-- Replace with your Subnet ID
  vpc_security_group_ids = ["sg-006c381bef796d485"]   # <-- Replace with your SG ID (Port 80 open)

  # CONNECTION 1: IAM Module ka Output seedha EC2 Module ke Input mein!
  iam_instance_profile = dependency.iam.outputs.instance_profile_name

  # CONNECTION 2: Local Machine se User Data Script ka exact path (Module ka file() padhega)
  user_data_script_path = "${get_terragrunt_dir()}/user_data.sh"

  # CONNECTION 3: Dynamic Filter Map jo Packer ki Nginx AMI dhoondhega!
  ami_owners = ["self"]
  ami_filters = {
    "name"        = ["custom-nginx-ubuntu-*-IST"]
    "tag:Role"    = ["frontend-nginx"]
    "tag:Builder" = ["Packer"]
    "state"       = ["available"]
  }

  extra_tags = {
    Service = "Web-Tier"
  }
}