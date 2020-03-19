#AZs for Subnet 
data "aws_availability_zones" "available" {
  state = "available"
}
