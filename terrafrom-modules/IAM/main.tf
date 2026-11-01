
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(
    {
      Name      = var.role_name
      ManagedBy = "Terraform-Terragrunt"
    },
    var.extra_tags
  )
}


resource "aws_iam_role_policy_attachment" "managed" {
  # MAGIC LINE: toset() list ko Set mein badal deta hai, jisse Policy ARN khud Index ban jata hai!
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value # Yahan 'each.key' aur 'each.value' dono exact Policy ARN hain
}


resource "aws_iam_instance_profile" "this" {
  name = "${var.role_name}-profile"
  role = aws_iam_role.this.name

  tags = merge(
    {
      Name      = "${var.role_name}-profile"
      ManagedBy = "Terraform-Terragrunt"
    },
    var.extra_tags
  )
}