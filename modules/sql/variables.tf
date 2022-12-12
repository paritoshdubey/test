variable "network" {
  description = "Self link of the VPC for the address range allocation"
  type        = string
}

variable "project_id" {
  description = "Project ID for this resource"
  type        = string
}

variable "address_ranges" {
  description = "IP address ranges to allocate"
  type = list(object({
    ip_range  = string
    region    = string
    create_db = bool
  }))
}

variable "kind" {
  description = "Which kind of database instance to create: psql for PostgreSQL and mysql for both MySQL and MS SQLServer"
  type        = string
  validation {
    condition     = length(regexall("^psql$|^mysql$", var.kind)) == 0 ? false : true
    error_message = "The kind of Cloud SQL databse must have one of these values: psql or mysql."
  }
}
