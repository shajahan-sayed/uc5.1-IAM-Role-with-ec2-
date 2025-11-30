#creating role
resource "aws_iam_role" "ec2_role" {
   name = "ec2_role"

#trust policy
   assume_role_policy = jsonecode({
      version = "2012-10-17"
      statement = [
             {
               Effect = "Allow"
               principal =  {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#creating the permission policy for S3,DYNAMODB,CLOUDWATCH
resource "aws_iam_policy" "ec2_policy" {
   policy = jsonecode ({
      version = "2012-10-17"
      statement = [
            {
            Effect = "Allow"
           Action = [
          "s3:Get*",
          "s3:List*",
          "s3:Put*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
      }
    ]
  })
}

#attach policy to the IAM role 

resource "aws_iam_role_policy_attachment" "ec2_attach" {
   role = aws_iam_role.ec2_role.name
   policy = aws_iam_policy.ec2_policy.arn
}

#creating instance profile and attaching it to role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2AccessInstanceProfile"
  role = aws_iam_role.ec2_role.name
}            

resource "aws_instance" "ec2_example" {
  ami           = var.ami_id
  instance_type = var.instance_type

  aws_iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  tags = {
    Name = "EC2WithIAMRole"
  }
}
