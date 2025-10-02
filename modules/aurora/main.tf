resource "aws_rds_global_cluster" "main" {
  provider              = aws.primary
  global_cluster_identifier = "app-global-db"
  engine                    = "aurora-mysql"
  engine_version            = "8.0.mysql_aurora.3.08.2"
  database_name             = "appdb"
  storage_encrypted         = true
}

resource "aws_rds_cluster" "primary" {
  provider                  = aws.primary
  cluster_identifier        = "app-primary-cluster"
  global_cluster_identifier = aws_rds_global_cluster.main.id
  engine                    = "aurora-mysql"
  engine_version            = "8.0.mysql_aurora.3.08.2"
  database_name             = "appdb"
  master_username           = var.db_username
  master_password           = var.db_password
  vpc_security_group_ids    = [var.primary_db_sg_id]
  db_subnet_group_name      = aws_db_subnet_group.primary.name
  skip_final_snapshot       = true
}

resource "aws_rds_cluster_instance" "primary" {
  provider           = aws.primary
  count              = 1
  identifier         = "app-primary-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.primary.id
  instance_class     = "db.r5.large"
  engine             = "aurora-mysql"
}

resource "aws_db_subnet_group" "primary" {
  provider   = aws.primary
  name       = "app-primary-subnet-group"
  subnet_ids = var.primary_subnets
}

resource "aws_rds_cluster" "secondary" {
  provider                  = aws.secondary
  cluster_identifier        = "app-secondary-cluster"
  global_cluster_identifier = aws_rds_global_cluster.main.id
  engine                    = "aurora-mysql"
  engine_version            = "8.0.mysql_aurora.3.08.2"
  # database_name             = "appdb"
  vpc_security_group_ids    = [var.secondary_db_sg_id]
  db_subnet_group_name      = aws_db_subnet_group.secondary.name
  skip_final_snapshot       = true
  storage_encrypted = true
  kms_key_id        = aws_kms_key.secondary_rds.arn
  # waits till primary create and then create secondary
   depends_on = [
    aws_rds_cluster_instance.primary
  ]

}

resource "aws_rds_cluster_instance" "secondary" {
  provider           = aws.secondary
  count              = 1
  identifier         = "app-secondary-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.secondary.id
  instance_class     = "db.r5.large"
  engine             = "aurora-mysql"
}

resource "aws_db_subnet_group" "secondary" {
  provider   = aws.secondary
  name       = "app-secondary-subnet-group"
  subnet_ids = var.secondary_subnets
}
# kms key creation for secondary region as we are replicating, each region has diff KMS key
resource "aws_kms_key" "secondary_rds" {
  provider = aws.secondary
  description = "KMS key for secondary Aurora cluster"
  deletion_window_in_days = 10
}