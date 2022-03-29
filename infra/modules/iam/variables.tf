variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
}

variable "workstation-external-cidr" {
  description = "workstation cidr"
  type        = string
}

variable "aws_vpc_id" {
  description = "aws vpc id"
  type        = string
}
