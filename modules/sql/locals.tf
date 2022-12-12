locals {
  # Abbreviated region codes to avoid long names
  # Could've been some complex regexes but that would generate quite un-readable code
  abbr_region = {
    asia-east1              = "ases1"
    asia-east2              = "ases2"
    asia-northeast1         = "asne1"
    asia-northeast2         = "asne2"
    asia-northeast3         = "asne3"
    asia-south1             = "asso1"
    asia-southeast1         = "asse1"
    asia-southeast2         = "asse2"
    australia-southeast1    = "ause1"
    europe-north1           = "euno1"
    europe-west1            = "euwe1"
    europe-west2            = "euwe2"
    europe-west3            = "euwe3"
    europe-west4            = "euwe4"
    europe-west6            = "euwe6"
    northamerica-northeast1 = "nane1"
    southamerica-east1      = "saea1"
    us-central1             = "usce1"
    us-east1                = "usea1"
    us-east4                = "usea4"
    us-west1                = "uswe1"
    us-west2                = "uswe2"
    us-west3                = "uswe3"
    us-west4                = "uswe4"
  }
  address_ranges = {
    for a in var.address_ranges :
    format("sa-%s-%s", var.kind, replace(a.ip_range, "/\\.|\\//", "-")) => {
      address       = split("/", a.ip_range)[0]
      prefix_length = split("/", a.ip_range)[1]
    }
  }
  db_instances = {
    for i in var.address_ranges :
    format("db-%s-%s", var.kind, local.abbr_region[i.region]) => i.region if i.create_db == true
  }
}
