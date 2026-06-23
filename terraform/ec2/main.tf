provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

resource "aws_security_group" "ssh_sg" {
  name        = "ssh-access"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jupyter Lab"
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "client" {
  bucket = "${var.bucket_name}-client-${random_id.bucket_suffix.hex}"
}

resource "aws_s3_bucket_versioning" "versioning-client" {
  bucket = aws_s3_bucket.client.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_instance" "jupyter" {
  ami                    = var.ubuntu_ami
  instance_type          = "t3.medium"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]

  tags = {
    Name = "narwhal-jupyter-ec2"
  }
}


resource "aws_ebs_volume" "narwhal_data" {
  availability_zone = aws_instance.jupyter.availability_zone
  size              = 20   
  type              = "gp3"

  tags = {
    Name = "narwhal-jupyter-ebs"
  }
}

resource "aws_volume_attachment" "jupyter_data_attach" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.narwhal_data.id
  instance_id = aws_instance.narwhal_data.id
}

output "client_bucket_name" {
  value = aws_s3_bucket.client.bucket
}

output "ec2_public_ip" {
  value = aws_instance.jupyter.public_ip
}

output "client_bucket_arn" {
  value = aws_s3_bucket.client.arn
}

output "ssh_sg_id" {
  value = aws_security_group.ssh_sg.id
}
