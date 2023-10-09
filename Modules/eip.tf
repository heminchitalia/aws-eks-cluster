resource "aws_eip" "nat1" {
  depends_on = [aws_internet_gateway.eksigw]
}

resource "aws_eip" "nat2" {
  depends_on = [aws_internet_gateway.eksigw]
}