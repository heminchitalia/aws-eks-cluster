resource "aws_internet_gateway" "eksigw" {
  vpc_id = aws_vpc.eks-demo-cluster.id
  tags = {
    Name = "eks-demo-igw"
  }
}