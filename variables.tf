variable "linode_token" {}

variable "region" {
  default = "ap-northeast"
}

variable "image_path" {
  default = "./result/nixos.img.gz"
}

variable "instance_type" {
  default = "g6-nanode-1"
}

variable "terraform_cloud_token" {
}

variable "nixos_size" {
  default = 10 * 1024
}

variable "swap_size" {
  default = 512
}
