## TF file for IAM users and groups

resource "aws_iam_user" "adminuser1" {
    name = "adminuser1"
}

resource "aws_iam_user" "adminuser2" {
    name = "adminuser2"
  
}

##group

resource "aws_iam_group" "admingroup" {
  name = "admingroup"
}

##associate the users with the admingroup
resource "aws_iam_group_membership" "admin-users" {
    name = "admin-users"
    users = [
        aws_iam_user.adminuser1.name,
        aws_iam_user.adminuser2.name
    ]
    group = [aws_iam_group.admingroup]
  
}

##create policy

resource "aws_iam_policy_attachment" "admin-user-attachment" {
  name = "admin-user-attachment"
  groups = [aws_iam_group.admingroup]
  policy_arn = "arn:aws:iam::aws:policy/AdminstratorAccess"
}

# Let's break this ARN (Amazon Resource Name) down step by step:
# 1️⃣ arn: → This is the prefix for all AWS resource identifiers.
# 2️⃣ aws: → Specifies that the resource belongs to AWS.
# 3️⃣ iam: → Refers to AWS Identity and Access Management (IAM), which handles user roles and permissions.
# 4️⃣ ::aws: → Indicates that this is a global AWS-managed policy, meaning it's provided by AWS and not tied to a specific AWS account.
# 5️⃣ policy/AdministratorAccess → This is the specific policy name. The AdministratorAccess policy grants full permissions across all AWS services.
