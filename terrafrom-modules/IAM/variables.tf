variable "role_name" {
  description = "IAM Role aur Instance Profile ka naam"
  type        = string
}

variable "managed_policy_arns" {
  description = "List of AWS Managed Policy ARNs (Future mein kitni bhi add karo, index shift nahi hoga)"
  type        = list(string)
  default     = []
 
}

variable "extra_tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}