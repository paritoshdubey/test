module "forgerock_idm" {
  source = "./modules/namespace-with-workloads"

  namespace_name = "test"

  secrets_project_id = var.secrets_project_id

  secrets = {
    "test" = {
      "abcd" = "xyz"

  }
  service_accounts = {
    test = { google_service_account_email = "test@${var.cluster_project_id}.iam.gserviceaccount.com" }
  }

  helm_releases = {
    forgerock-example = {
      chart                  = "example"
      version                = "1.0.17"
      workloadServiceAccount = "example"
      values                 = {
        imagePullSecret = "gcp-artifactory"
        

        resourceConstraints = {
          limits = {
            mem = "6Gi"
          }
          requests = {
            mem = "6Gi"
            cpu = 4
          }
        }

        minReplicas           = 2
        maxReplicas           = 6
        averageCpuUtilization = 70
        averageMemoryValue    = "6500Mi"

        grade                = var.grade
      }
    }
  }
}
