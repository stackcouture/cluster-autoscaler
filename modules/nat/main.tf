resource "aws_eip" "eip_vpc" {
  domain = "vpc"

  tags = {
    Name = var.eip_name
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip_vpc.id
  subnet_id     = element(var.public_subnet_ids, 0)
  tags = {
    Name = var.nat_gw_name
  }
  depends_on = [var.igw_id]
}