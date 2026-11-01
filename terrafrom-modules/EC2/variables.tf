# terraform-modules/ec2/variables.tf

variable "instance_name" {
  description = "EC2 instance ka Name tag"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t3.micro"
}

variable "ami_owners" {
  description = "Kis AWS account ki AMI search karni hai"
  type        = list(string)
  default     = ["self"]
}

variable "ami_filters" {
  description = "Dynamic filters map jo Terragrunt pass karega Packer AMI dhoondhne ke liye"
  type        = map(list(string))
}

variable "subnet_id" {
  description = "VPC Subnet ID"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of Security Group IDs (Sirf Port 80 Inbound chahiye, Port 22 bilkul nahi!)"
  type        = list(string)
  default     = []
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile Name (SSM login ke liye mandatory hai)"
  type        = string
}

# ==============================================================================
# NAYA VARIABLE: Local Machine se User Data Script ka Path lene ke liye
# ==============================================================================
variable "user_data_script_path" {
  description = "Local machine par rakhi .sh script ka path (e.g., ./user_data.sh). Agar nahi chahiye toh null."
  type        = string
  default     = null
}

variable "extra_tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}