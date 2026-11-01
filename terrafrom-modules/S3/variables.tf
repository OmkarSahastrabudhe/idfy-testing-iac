variable "bucket_name" {
  description = "S3 Bucket ka globally unique naam"
  type        = string
}

variable "enable_versioning" {
  description = "File versioning ON rakhni hai ya nahi (Prod ke liye true)"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Agar true hai, toh bhare hue bucket ko bhi terraform destroy uda dega (Prod mein false rakho, Dev/Test mein true)"
  type        = bool
  default     = false
}

variable "kms_master_key_id" {
  description = "Optional: Agar custom KMS key use karni hai toh ARN do, warna null rehne par default AWS S3 key (AES256) lagegi"
  type        = string
  default     = null
}

variable "extra_tags" {
  description = "Additional tags jo Terragrunt se aayenge"
  type        = map(string)
  default     = {}
}