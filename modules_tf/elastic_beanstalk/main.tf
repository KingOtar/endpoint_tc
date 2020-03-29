resource "aws_elastic_beanstalk_application" "endpoint_elastic_beanstalk_app" {
  name        = "${var.project_name}_application"
  description = "For technical test"
}

resource "aws_elastic_beanstalk_environment" "endpoint_elastic_beanstalk_environment" {
  name                = "${var.project_name}-environment"
  application         = aws_elastic_beanstalk_application.endpoint_elastic_beanstalk_app.name
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.14.2 running Docker 18.09.9-ce"

	wait_for_ready_timeout  = "40m"

	setting {
		namespace		= "aws:autoscaling:launchconfiguration"
		name				= "IamInstanceProfile"
		value				=	"aws-elasticbeanstalk-ec2-role"

	}

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

	setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = var.public_subnet_id
  }

	setting {
		namespace = "aws:elasticbeanstalk:environment"
		name			= "ServiceRole"
		value			= "aws-elasticbeanstalk-ec2-role"
	}

	setting {
		namespace = "aws:elb:listener"
		name			= "InstancePort"
		value			= "80"
	}

	#	launch_configuration = [aws_launch_configuration.eb_conf.name]

}

resource "aws_iam_policy" "endpoint-ecr-policy" {
  name        = "${var.project_name}EcrPolicy"
  description = "attach to existing role to give access to ecr"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

data "aws_iam_role" "endpoint_beanstalk_policy_lookup" {
  name = "aws-elasticbeanstalk-ec2-role"
}


resource "aws_iam_role_policy_attachment" "endpoint-ecr-policy-attach" {
  role       = data.aws_iam_role.endpoint_beanstalk_policy_lookup.name
  policy_arn = aws_iam_policy.endpoint-ecr-policy.arn

}

