##Roles to access the S3 bucket

resource "aws_iam_role" "levelup-role-s3" {
  name = "levelup-role-s3"
  assume_role_policy = <<EOF
  {
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Roles to access the S3 bucket",
			"Effect": "Allow",
			"Principal": {"services": "ec2.amazonaws.com"},
			"Action": "sts:AssumeRole"
		}
	]
  }
  EOF
}

## syntax for ARN: arn:partition:service:region:account-id:resource


# 1️⃣ Version": "2012-10-17" → Defines the policy version. This date is standard for AWS policies.
# 2️⃣ Statement → The main policy block containing rules.
# 3️⃣ Sid": "Statement1" → A unique identifier for the statement (optional).
# 4️⃣ Effect": "Allow" → Grants permission (in this case, allowing something to happen).
# 5️⃣ Principal": {} → Specifies who can assume the role. The empty {} means no specific entity is assigned yet, which must be defined.
# 6️⃣ Action": "sts:AssumeRole" → Allows the principal to assume the role using AWS Security Token Service (STS).


##create the policy and attach it to the role

resource "aws_iam_role_policy" "levelup-role-policy" {
  name = "levelup-role-policy"
  role = aws_iam_role.levelup-role-s3.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
            ],
            "Resource": [
              "arn:aws:s3:::levelup-role-s3",
              "arn:aws:s3:::levelup-role-s3/*"
            ]
        }
    ]
}
EOF

}


## Instance Identifier

resource "aws_iam_instance_profile" "instanceprofile-s3" {
    name = "instanceprofile-s3"
    role = aws_iam_role.levelup-role-s3.name
  
}
