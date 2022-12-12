module "kubernetes_secrets_cryptokey_europe_west3" {
  source  = "terraform-google-modules/kms/google"
  version = "1.4.1"
  
  depends_on = [module.cluster_project]

  sensitive_service_account_email = var.sensitive_service_account_email

  location = "europe-west3"
  keyring  = "gcp_google_kubernetes_engine_secret"
  key      = "kubernetes-secrets"

  key_rotation_period = "5097600s"

  labels = {
    usage = "kubernetes"
  }

  encrypters_decrypters = ["serviceAccount:service-${module.cluster_project.project_number}@container-engine-robot.iam.gserviceaccount.com"]

  # Following section not supported yet
  # lifecycle {
  #   prevent_destroy = true
  # }
}