variable "region" {
  type    = string
  default = "us-east-2"
}
variable "name" {
  type    = string
  default = "jenkins-eks"
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}
variable "key_name" {
  type = string
}
variable "allowed_cidr" {
  type = string
}

variable "github_repo_url" {
  type = string
}
variable "github_branch" {
  type    = string
  default = "main"
}
