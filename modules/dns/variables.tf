/*
"Copyright 2021 by Google. Your use of any copyrighted material and any warranties, if applicable, are subject to your agreement with Google."
*/

variable "namespace" {
  description = "Service Directory namespace selflink (projects/SERVICE_DIRECTORY_NAMESPACE_PROJECT_ID/locations/REGION/namespaces/NAMESPACE_ID)"
  type = string
}

variable "config" {
  description = "Service and endpoint configuration"
  type = map(map(object({
    address  = string
    port     = number
	})))
}

variable "nar_id" {
  type = string
  description = "LZ Tenant NAR ID"
}