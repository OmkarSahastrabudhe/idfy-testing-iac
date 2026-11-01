# terraform-modules/ec2/outputs.tf

output "selected_packer_ami_id" {
  description = "Packer ki konsi AMI ID select hui"
  value       = data.aws_ami.packer_ami.id
}

output "selected_packer_ami_name" {
  description = "Packer ki konsi AMI Name select hui"
  value       = data.aws_ami.packer_ami.name
}

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.this.public_ip
}

output "ssm_login_command" {
  description = "Terminal se direct SSM login karne ki command"
  value       = "aws ssm start-session --target ${aws_instance.this.id}"
}