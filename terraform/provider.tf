provider "aws" {

  default_tags {

    tags = {
      Project     = var.project_name
      Environment = var.project_environment
    }
  }
}
