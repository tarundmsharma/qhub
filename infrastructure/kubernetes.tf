provider "kubernetes" {

  host                   = module.kubernetes.credentials.endpoint
  cluster_ca_certificate = module.kubernetes.credentials.cluster_ca_certificate
  token                  = module.kubernetes.credentials.token

}

provider "kubernetes-alpha" {

  host                   = module.kubernetes.credentials.endpoint
  cluster_ca_certificate = module.kubernetes.credentials.cluster_ca_certificate
  token                  = module.kubernetes.credentials.token

}


module "kubernetes-initialization" {
  source = "github.com/quansight/qhub-terraform-modules//modules/kubernetes/initialization?ref=release-0.3.11"

  namespace = var.environment
  secrets   = []
}


module "kubernetes-nfs-server" {
  source = "github.com/quansight/qhub-terraform-modules//modules/kubernetes/nfs-server?ref=release-0.3.11"

  name         = "nfs-server"
  namespace    = var.environment
  nfs_capacity = "15Gi"
  node-group   = local.node_groups.general

  depends_on = [
    module.kubernetes-initialization
  ]
}

module "kubernetes-nfs-mount" {
  source = "github.com/quansight/qhub-terraform-modules//modules/kubernetes/nfs-mount?ref=release-0.3.11"

  name         = "nfs-mount"
  namespace    = var.environment
  nfs_capacity = "15Gi"
  nfs_endpoint = module.kubernetes-nfs-server.endpoint_ip

  depends_on = [
    module.kubernetes-nfs-server
  ]
}


module "kubernetes-conda-store-server" {
  source = "github.com/quansight/qhub-terraform-modules//modules/kubernetes/services/conda-store?ref=release-0.3.11"

  name         = "qhub"
  namespace    = var.environment
  nfs_capacity = "10Gi"
  node-group   = local.node_groups.general
  environments = {

    "environment-dask.yaml" = file("../environments/environment-dask.yaml")

    "environment-dashboard.yaml" = file("../environments/environment-dashboard.yaml")

  }

  depends_on = [
    module.kubernetes-initialization
  ]
}

module "kubernetes-conda-store-mount" {
  source = "github.com/quansight/qhub-terraform-modules//modules/kubernetes/nfs-mount?ref=release-0.3.11"

  name         = "conda-store"
  namespace    = var.environment
  nfs_capacity = "10Gi"
  nfs_endpoint = module.kubernetes-conda-store-server.endpoint_ip

  depends_on = [
    module.kubernetes-conda-store-server
  ]
}

provider "helm" {
  kubernetes {

    load_config_file       = false
    host                   = module.kubernetes.credentials.endpoint
    cluster_ca_certificate = module.kubernetes.credentials.cluster_ca_certificate
    token                  = module.kubernetes.credentials.token
  }
}

module "kubernetes-ingress" {
  source = "github.com/quansight/qhub-terraform-modules//modules/kubernetes/ingress?ref=release-0.3.11"

  namespace = var.environment

  node-group = local.node_groups.general



  depends_on = [
    module.kubernetes-initialization
  ]
}

module "qhub" {
  source = "github.com/quansight/qhub-terraform-modules//modules/kubernetes/services/meta/qhub?ref=release-0.3.11"

  name      = "qhub"
  namespace = var.environment

  home-pvc        = module.kubernetes-nfs-mount.persistent_volume_claim.name
  conda-store-pvc = module.kubernetes-conda-store-mount.persistent_volume_claim.name

  external-url = var.endpoint

  jupyterhub-image   = var.jupyterhub-image
  jupyterlab-image   = var.jupyterlab-image
  dask-worker-image  = var.dask-worker-image
  dask-gateway-image = var.dask-gateway-image

  general-node-group = local.node_groups.general
  user-node-group    = local.node_groups.user
  worker-node-group  = local.node_groups.worker



  jupyterhub-overrides = [
    file("jupyterhub.yaml")
  ]

  dask_gateway_extra_config = file("dask_gateway_config.py.j2")

  depends_on = [
    module.kubernetes-ingress
  ]
}

