resource "aws_iam_role" "s3-db-access" {
  name = "s3-db-FullAccess"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "ec2-profile-s3" {
  name = "ec2-profile-s3"
  role = aws_iam_role.s3-db-access.name
}

resource "aws_iam_role_policy" "s3-fullAccess-p" {
  name = "s3-fullAccess-p"
  role = aws_iam_role.s3-db-access.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "db-fullAccess-p" {
  name = "db-fullAccess-p"
  role = aws_iam_role.s3-db-access.id

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Action": [
             "rds-db:connect"
         ],
         "Resource": "*"
      }
   ]
}
EOF
}
