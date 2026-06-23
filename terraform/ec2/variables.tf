variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "ubuntu_ami" {
  description = "Ubuntu AMI ID for the EC2 instance (region-specific)"
  type        = string
  default     = "ami-0f8cdf1d816ae220f"
}

variable "bucket_name" {
  description = "Base name for the S3 client bucket (a random suffix will be appended)"
  type        = string
  default     = "narwhal"
}
