/*
"Copyright 2021 by Google. Your use of any copyrighted material and any warranties, if applicable, are subject to your agreement with Google."
*/

terraform {
  required_version = ">= 0.12.6"

  required_providers {
    google-beta = {
      version = ">= 3.9.0"
    }
    google = {
      version = ">= 3.9.0"
    }
  }
}