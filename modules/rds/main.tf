resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [
    var.subnet_ids[0],
    var.subnet_ids[1]
  ]
}


resource "aws_db_instance" "salesync_rds" {
  allocated_storage = 5
  max_allocated_storage = 20
  availability_zone = "ap-northeast-2a"
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  engine = "postgres"
  engine_version = "15.4"
  instance_class = "db.t3.micro"
  skip_final_snapshot = true
  identifier = "salesync-rds"
  db_name = var.db_name
  username = var.db_username
  password = var.db_password
  port = 5432
}