#Output webserver private ip
output "webserver_private_ip" {
  value = aws_instance.webserver.private_ip
}
#Output rds address
output "rds_address" {
  value = aws_db_instance.main-rds.address
}
