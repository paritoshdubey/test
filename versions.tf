/*
  Terraform Providers should be defined in this file
  https://www.terraform.io/docs/configuration/provider-requirements.html
*/

terraform {
  required_version = "0.14.11"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.90.1"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }

  # Attributes to be set by TFE and Kitchen
  backend "remote" {}
}
