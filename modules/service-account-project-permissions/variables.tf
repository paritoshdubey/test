variable "project_id" {
  type        = string
  description = "The Project ID to create this module's resource in"
}

variable "roles" {
  type        = set(string)
  description = "The roles to assign to the service account"
}

variable "service_account_email" {
  type        = string
  description = "The email of the service account to assign the roles"
}
