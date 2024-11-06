packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "project_image" {

  source_ami    = var.source_ami_id
  instance_type = var.source_instance_type
  ssh_username  = "ec2-user"
  ami_name      = local.full_image_name

  tags = {
    Name        = local.full_image_name
    Project     = var.project_name
    Environment = var.project_environment
    Commit      = var.git_commit_id
  }

}

build {

  sources = ["source.amazon-ebs.project_image"]

  provisioner "shell" {
    script           = "./setup.sh"
    execute_command  = "sudo {{.Path}}"
  }

  provisioner "file" {
    source      = "../website"
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = [
      "sudo cp -r /tmp/website/* /var/www/html/",
      "sudo rm -rf /tmp/website"
    ]
  }
}
