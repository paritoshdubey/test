module "cluster_project" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"

  project_name = "cluster"
  
  activate_apis = [
    "binaryauthorization.googleapis.com",
    "cloudresourcemanager.googleapis.com",    
    "compute.googleapis.com",
    "container.googleapis.com",
    "gkeconnect.googleapis.com",
    "gkehub.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "stackdriver.googleapis.com",
    "vpcaccess.googleapis.com",
    "secretmanager.googleapis.com",
    "servicedirectory.googleapis.com",
    "dns.googleapis.com",
    "cloudresourcemanager.googleapis.com",    
  ]
  
  activate_api_identities = [
    "anthos.googleapis.com",
    #"anthosconfigmanagement.googleapis.com",
    "binaryauthorization.googleapis.com",
    "container.googleapis.com",
    "gkehub.googleapis.com",
    "meshconfig.googleapis.com",
    "vpcaccess.googleapis.com",
    "secretmanager.googleapis.com",
    "sqladmin.googleapis.com",
    "artifactregistry.googleapis.com"
  ]
}

module "cluster_nodes_service_account_cluster_project_bindings" {
  source = "./modules/service-account-project-permissions"

  project_id            = module.cluster_project.project_id
  service_account_email = module.cluster_nodes_service_account.service_account_email
  roles = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
  ])
}

module "sql_service_account_cluster_project_bindings" {
  source = "./modules/service-account-project-permissions"

  project_id            = module.cluster_project.project_id
  service_account_email = module.sql_service_account.service_account_email
  roles = toset([
    "roles/cloudsql.client",
    "roles/logging.logWriter"
  ])
}