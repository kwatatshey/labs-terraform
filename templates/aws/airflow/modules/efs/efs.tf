# Retrieve security groups info based on provided security group name
data "aws_security_group" "efs_sg" {
  for_each = toset(var.efs_mount_targets_sg)
  name     = each.value

}

# Create EFS drive
resource "aws_efs_file_system" "efs_drive" {
  creation_token   = coalesce(var.creation_token, var.efs_name)
  encrypted        = true
  performance_mode = "generalPurpose"
  throughput_mode  = var.efs_throughput_mode

  tags = {
    Name = var.efs_name
  }

}

# Create mount targets attached to given EFS drive in each provided subnet.
resource "aws_efs_mount_target" "mount_targets" {
  for_each        = toset(var.efs_mount_targets_subnets)
  file_system_id  = aws_efs_file_system.efs_drive.id
  subnet_id       = each.key
  security_groups = [for sg in data.aws_security_group.efs_sg : sg.id]
}

# Enable backup for EFS drive
resource "aws_efs_backup_policy" "backup_efs" {
  file_system_id = aws_efs_file_system.efs_drive.id

  backup_policy {
    status = "ENABLED"
  }
}

# Define policy to be attached to EFS
data "aws_iam_policy_document" "policy_efs" {
  statement {
    sid    = "efs-statement"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
      "elasticfilesystem:ClientRootAccess",
    ]

    resources = [aws_efs_file_system.efs_drive.arn]

    condition {
      test     = "Bool"
      variable = "elasticfilesystem:AccessedViaMountTarget"
      values   = ["true"]
    }
  }
}

# Attach file system policy to EFS
resource "aws_efs_file_system_policy" "attach_policy_efs" {
  file_system_id = aws_efs_file_system.efs_drive.id
  policy         = data.aws_iam_policy_document.policy_efs.json
}