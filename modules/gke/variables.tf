variable "project" {
  type        = string
  description = "The project id where to deploy the GKE cluster"
}

variable "name" {
  type        = string
  description = "The name of the cluster. Will also be used as name or prefix for related resources"
}

variable "zones" {
  type        = list(string)
  description = "The zones of the Kubernetes cluster, e.g. europe-west3-a"
}

variable "node_pools" {
  type        = map(map(string))
  description = "The node pools of the cluster. See https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest#node_pools-variable for which node pool options are available."
}

variable "node_pools_labels" {
  type        = map(map(string))
  description = "Map of maps containing node labels by node-pool name"
  default = {
    all               = {}
    default-node-pool = {}
  }
}

variable "node_pools_tags" {
  type        = map(list(string))
  description = "Map of lists containing node network tags by node-pool name"

  # Default is being set in variables_defaults.tf
  default = {
    all               = []
    default-node-pool = []
  }
}

variable "subnetwork_self_link" {
  type        = string
  description = "The self link to the subnetwork that already contains all information needed for the network."
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The IP range in CIDR notation to use for the hosted master network"
}
variable "service_account_email" {
  type        = string
  description = "The email of the service account for the Kubernetes cluster nodes"
}

variable "database_crypto_key_id" {
  type        = string
  description = "The name of the Cloud KMS crypto key with which the database is encrypted"
}

variable "boot_disk_kms_key_id" {
  type        = string
  description = "The KMS Key id for encrypting and decrypting the boot disks of the nodes"
}

variable "master_authorized_networks" {
  type        = map(string)
  description = "Defines ip ranges that may access the control plane. By default, access from the GitHub runners and DB development hardware is allowed. This option allows specifying additional ranges."
  default     = {}
}

variable "default_max_pods_per_node" {
  type        = number
  description = "The default maximum number of pods per node"
  default     = 64
}

variable "secondary_range_name_pods" {
  type        = string
  description = "The name of the secondary range within the subnet that will be used for the pods."
  default     = "pods"
}

variable "secondary_range_name_services" {
  type        = string
  description = "The name of the secondary range within the subnet that will be used for the services."
  default     = "services"
}

variable "enable_gke_hub_registration" {
  type        = bool
  description = "A switch to enable (true) or disable (false) GKE Hub registration."
  default     = true
}

variable "gke_hub_membership_id" {
  type        = string
  description = "The membership_id provided for registration of clusters, defaults to cluster name if not provided."
  default     = ""
}

variable "enable_policy_controller" {
  type        = bool
  description = "A switch to enable (true) or disable (false) config management policy controller. Requires var.enable_gke_hub_registration to be set to true."
  default     = true
}

variable "policy_controller_exemptable_namespaces" {
  type        = set(string)
  description = "A list of exemptable namespaces provided to the policy controller."
  default     = []
}

variable "config_management_version" {
  type        = string
  description = "The acm version used in the configmanagement"
  default     = "1.9.0"
}

variable "enable_binauthz" {
  type        = bool
  description = "A switch to enable (true) or disable (false) Binary Authorization. Requires var.enable_gke_hub_registration to be set to true."
  default     = true
}

variable "gce_pd_csi_driver" {
  type        = bool
  description = "A switch to enable (true) or disable (false) GCE PD CSI drivers."
  default     = false
}

variable "authorize_access_from_github_runners" {
  type    = bool
  default = true
}

variable "authorize_access_from_prodnet_dbras" {
  type    = bool
  default = false
}

variable "authorize_access_from_prodnet_wired" {
  type    = bool
  default = false
}

variable "authorize_access_from_devnet_devboxes_sdods_dods" {
  type    = bool
  default = false
}

variable "datapath_provider" {
  type        = string
  description = "The desired datapath provider for this cluster. By default, `DATAPATH_PROVIDER_UNSPECIFIED` enables the IPTables-based kube-proxy implementation. `ADVANCED_DATAPATH` enables Dataplane-V2 feature."
  default     = "ADVANCED_DATAPATH"
}

variable "network_policy" {
  type        = bool
  description = "Enable network policy addon. Disabled automatically if dataplane v2 is enabled"
  default     = true
}

variable "cluster_dns_provider" {
   type        = string
   description = "Which in-cluster DNS provider should be used. PROVIDER_UNSPECIFIED (default) or PLATFORM_DEFAULT or CLOUD_DNS."
   default     = "PROVIDER_UNSPECIFIED"
 }

 variable "cluster_dns_scope" {
   type        = string
   description = "The scope of access to cluster DNS records. DNS_SCOPE_UNSPECIFIED (default) or CLUSTER_SCOPE or VPC_SCOPE. "
   default     = "DNS_SCOPE_UNSPECIFIED"
 }

 variable "cluster_dns_domain" {
   type        = string
   description = "The suffix used for all cluster service records."
   default     = ""
 }

variable "cluster_domain" {
  type        = string
  description = "domain of cluster"
  default     = "de"
}

variable "issue_client_certificate" {
  type        = bool
  description = "Issues a client certificate to authenticate to the cluster endpoint. To maximize the security of your cluster, leave this option disabled. Client certificates don't automatically rotate and aren't easily revocable. WARNING: changing this after cluster creation is destructive!"
  default     = false
}

