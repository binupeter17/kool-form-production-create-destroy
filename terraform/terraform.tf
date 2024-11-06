terraform {
  backend "s3" {
    bucket = "terraform-git-oldmonk.online"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

