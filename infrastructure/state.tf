terraform {
  backend "gcs" {
    bucket = "qhub-deployments-dev-terraform-state"
    prefix = "terraform/qhub-deployments"
  }
}
