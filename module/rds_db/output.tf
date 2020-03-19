#Output to set CloudWatch Alarms
output "rds_instance_id" {
  value = "${aws_db_instance.rds_prod}"
}



// Output for the DB password
#  resource "aws_ssm_parameter" "postgres_password" {
#    value  = "${random_password.rds-password.result}"
#  }


output "rds_instance_password" {
  value = "${aws_db_instance.rds_prod.password}"
}