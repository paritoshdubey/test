module "cluster_workload_service_accounts" {
  source   = "terraform-google-modules/service-accounts/google//examples/single_service_account"
  version  = "1.3.4"

  project_id  = module.cluster_project.project_id

  purpose      = "Cluster Workload for DS backup operator"
  account_id   = "ds-backup-operator"
  display_name = "DS backup operator Cluster Workload Service Account"
  access_level = "Project"
  is_temporary = false
  used_in      = "Std" 
}

module "sql_workload_service_accounts" {
  source   = "terraform-google-modules/service-accounts/google//examples/single_service_account"
  version  = "1.3.4"

  project_id  = module.cluster_project.project_id

  purpose      = "SQL Workload"
  account_id   = "sql-operator"
  display_name = "SQL operator Workload Service Account"
  access_level = "Project"
  is_temporary = false
  used_in      = "Std" 
}

resource "google_service_account_iam_member" "sql_workload_identity_user" {
  
  service_account_id = module.sql_workload_service_accounts.service_account_id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.cluster_project.project_id}.svc.id.goog[test/app]"
}

resource "google_service_account_iam_member" "cluster_workload_identity_user" {
  
  service_account_id = module.cluster_workload_service_accounts.service_account_id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.cluster_project.project_id}.svc.id.goog[test/app]"
}