resource "kubernetes_namespace" "namespace" {
  count = var.create_namespace ? 1 : 0
  metadata {
    name = var.namespace_name

    labels = var.enable_istio_sidecar_injection ? {
      "istio.io/rev" = "asm-managed-stable"
    } : {}
  }
}

data "kubernetes_namespace" "namespace" {
  count = var.create_namespace ? 0 : 1
  metadata {
    name = var.namespace_name
  }
}

locals {
  namespace_name = var.create_namespace ? kubernetes_namespace.namespace.0.metadata.0.name : data.kubernetes_namespace.namespace.0.metadata.0.name
}

resource "helm_release" "namespace_config" {
  name      = "namespace-config"
  chart     = "${path.module}/helm-chart"
  namespace = local.namespace_name
  atomic    = true
  values = [yamlencode({
    secretsProjectId           = var.secrets_project_id
    secrets                    = var.secrets
    createGcpArtifactorySecret = var.create_gcp_artifactory_secret
    serviceAccounts = { for sa_name, sa_options in var.service_accounts : sa_name =>
      {
        googleServiceAccountEmail = sa_options.google_service_account_email
      }
    }
  })]
}

resource "helm_release" "helm_releases" {
  for_each = var.helm_releases

  name       = each.key
  repository = can(regex("/", each.value.chart)) ? null : "gcp-artifactory-hlm-all" # Unless there's a slash, use gcp-artifactory-hlm-all repo
  chart      = each.value.chart
  version    = each.value.version != "" ? each.value.version : null
  namespace  = local.namespace_name
  atomic     = false
  values     = [yamlencode(each.value.values)]
  devel      = true
  timeout    = 600

  depends_on = [
    helm_release.namespace_config,
  ]
}

data "helm_template" "rendered_helm_releases" { # For validation
  for_each = var.helm_releases

  name       = each.key
  repository = can(regex("/", each.value.chart)) ? null : "gcp-artifactory-hlm-all" # Unless there's a slash, use gcp-artifactory-hlm-all repo
  chart      = each.value.chart
  version    = each.value.version != "" ? each.value.version : null
  namespace  = local.namespace_name
  atomic     = true
  values     = [yamlencode(each.value.values)]
  devel      = true
}
