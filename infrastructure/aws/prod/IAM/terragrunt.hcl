# terragrunt-live/prod/iam/terragrunt.hcl

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../terrafrom-modules//iam"
}

inputs = {
  role_name = "omkar-prod-nginx-ec2-role"

  # List of Managed Policies (Module ke andar toset() laga hai, toh index kabhi nahi hilega!)
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", # Mandatory for Keyless SSM Login
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",       # EC2 se S3 bucket dekhne ke liye
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"   # Logs/Metrics ke liye
  ]

  extra_tags = {
    Service = "Security-IAM"
  }
}