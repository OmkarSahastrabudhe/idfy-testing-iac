# terragrunt-live/prod/s3/terragrunt.hcl

# 1. Parent root.hcl se backend aur provider le aao
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# 2. Terraform S3 Module ka path (Double slash '//' Terragrunt standard hai)
terraform {
  source = "../../../../terrafrom-modules//S3"
}

# 3. Variables pass karo
inputs = {
  bucket_name       = "omkar-prod-app-artifacts-2026"
  enable_versioning = true
  force_destroy     = true # Testing ke baad easily destroy karne ke liye true rakha hai

  extra_tags = {
    Service = "Storage-Layer"
  }
}