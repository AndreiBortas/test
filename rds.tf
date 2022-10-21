resource "aws_db_instance" "mysql-db" {
  name                   = "myPersonalDBInstance"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username               = "admin12345"
  password               = "admin12345"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.my-db-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds-sb-grp.id
}

resource "aws_db_subnet_group" "rds-sb-grp" {
  name       = "main"
  subnet_ids = [aws_subnet.subnet[1].id, aws_subnet.subnet[2].id]

  tags = {
    Name = "My DB subnet group"
  }
}
