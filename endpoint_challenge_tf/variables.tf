variable "project_name" {} 

variable "aws_region" {
    default = "us-east-1"
}

variable "amis" {
    default = {
        es-east-1 = "ami-0f90a34c9df977efb" # Amazon Linux
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}
