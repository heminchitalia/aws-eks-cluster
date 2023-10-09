resource "aws_vpc" "eks-demo-cluster" {
  cidr_block           = "192.168.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-demo-cluster"
  }
}

output "vpc_id" {
  value       = aws_vpc.eks-demo-cluster.id
  description = "VPC id."
  sensitive   = false

}