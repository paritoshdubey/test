variable "namespace_name" {
  type = string
}

variable "create_namespace" {
  type    = bool
  default = true
}

variable "enable_istio_sidecar_injection" {
  type    = bool
  default = true
}

variable "secrets_project_id" {
  description = "The GCP project used for Google Secret Manager. Needed to create the the image pull secret and application secrets"
  type        = string
}

variable "create_gcp_artifactory_secret" {
  type    = bool
  default = true
}

variable "secrets" {
  type    = map(map(string))
  default = {}
}

variable "service_accounts" {
  type = map(object({
    google_service_account_email = string
  }))
  default = {}
}

variable "helm_releases" {
  # type = map(object({
  #  chart   = string
  #  version = string
  #  values  = any
  #}))
  default = {}
}
