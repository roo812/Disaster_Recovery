output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_subnets" {
  value = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "ec2_sg_id" {
  value = aws_security_group.ec2.id
}

output "db_sg_id" {
  value = aws_security_group.db.id
}