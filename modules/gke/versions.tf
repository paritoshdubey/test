terraform {
  required_version = ">= 0.14"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.35.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.35.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.1"
    }
  }
}
