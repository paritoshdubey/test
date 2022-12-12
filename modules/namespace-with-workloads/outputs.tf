output "namespace_name" {
  description = "The name of the namespace. Becomes ready after all Kubernetes resources are deployed"
  value       = local.namespace_name

  depends_on = [
    helm_release.namespace_config,
    helm_release.helm_releases,
  ]
}
