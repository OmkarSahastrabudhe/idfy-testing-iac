
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    # Apna unique bucket name rakhna (Terragrunt automatically create kar dega)
    bucket         = "terragrunt-bucket-cdec"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    
  }
}


generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Environment = "Production"
      Owner       = "Omkar"
      Orchestrator = "Terragrunt"
    }
  }
}
EOF
}