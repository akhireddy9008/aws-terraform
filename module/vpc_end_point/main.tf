#Create the VPC end point
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = var.endpoint_service

}
# associate route table with VPC endpoint
resource "aws_vpc_endpoint_route_table_association" "route_table_association" {
  route_table_id  = var.vpc_route_table
  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
}