variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "ami_id" {
  type    = string
  default = "ami-0b8d527345fdace59" 
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
