output "role_name" {
  description = "Created IAM Role Name"
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "Created IAM Role ARN"
  value       = aws_iam_role.this.arn
}

output "instance_profile_name" {
  description = "YEH OUTPUT EC2 MODULE MEIN PASS HOGA!"
  value       = aws_iam_instance_profile.this.name
}

output "instance_profile_arn" {
  description = "IAM Instance Profile ARN"
  value       = aws_iam_instance_profile.this.arn
}