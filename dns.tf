module "germany-dns-records" {
  source  = "./modules/dns"
  version = "1.0.3"
  namespace = var.namespace
  
  config = {
    test = { # service
      api = { # endpoint
        address = google_compute_address.internal-static-ip.address
        port    = "443"
      }
    }    
  }
}


