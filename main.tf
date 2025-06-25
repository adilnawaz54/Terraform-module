terraform {
  backend "s3" {
    bucket         = "tfstate-bucket-54"
    key            = "terraform-module/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "demo" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  root_block_device {
    volume_size           = var.volume_size   
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "Terraform-Drift-Demo"
  }
}
