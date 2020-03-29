# This file is solely used to declare modules and pass inherited vars to modules.
module vpc {
	source = "../modules_tf/vpc"
	project_name	= var.project_name
	vpc_cidr = var.vpc_cidr
	public_subnet_cidr = var.public_subnet_cidr
}

module elastic_beanstalk {
	source = "../modules_tf/elastic_beanstalk"
	project_name =  var.project_name
	vpc_id = module.vpc.vpc_id
	public_subnet_id = module.vpc.public_subnet_id
}

module pipeline {
	source = "../modules_tf/pipeline"
	project_name = var.project_name
}

