module "cloudsql" {
  source = "./modules/sql"
  project                 = module.cluster_project.project_id
  name                    = var.postgres_instance_config1.pg_instance_name
  engine                  = var.postgres_instance_config1.pg_version
  machine_type            = var.postgres_instance_config1.pg_machinetype
  disk_size               = var.postgres_instance_config1.pg_disk_size
  disk_type               = var.postgres_instance_config1.pg_disk_type
  enable_failover_replica = var.postgres_instance_config1.pg_ha_required
  private_network         = "projects/${var.vpc_project_id}/global/networks/${var.network_name}"
  db_name                 = var.postgres_instance_config1.initial_dbname
  master_user_name        = var.postgres_instance_config1.initial_superuser
  master_user_password    = random_password.pgpassword.result
  region                  = var.postgres_instance_config1.pg_region
  encryption_key_name     = module.kubernetes_secrets_cryptokey_europe_west3.key_name #europe-west3
  master_zone             = ""
  database_flags          = var.pg_database_flags
  db_charset              = var.postgres_instance_config1.pg_charset
  db_collation            = var.postgres_instance_config1.pg_collation
}
  
resource "google_sql_user" "users" {
  name     = "db"
  instance = var.postgres_instance_config1.pg_instance_name
  project  = module.cluster_project.project_id
  type     = "CLOUD_IAM_USER"
}

# CloudSQL users for the GKE Workload Identities (GKE WI)
resource "google_sql_user" "wi_users" {
  name     = "db"
  instance = var.postgres_instance_config1.pg_instance_name
  project  = module.cluster_project.project_id
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
}