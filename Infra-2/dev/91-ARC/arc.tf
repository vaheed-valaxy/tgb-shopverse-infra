# -------------------------------------------------------
# ARC Controller
# -------------------------------------------------------
resource "helm_release" "controller" {
  name       = "arc-controller"
  namespace  = "arc-systems"
  repository = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart      = "gha-runner-scale-set-controller"
  version    = "0.15.0"

  create_namespace = true
}

# -------------------------------------------------------
# ARC Runner Scale Set
# -------------------------------------------------------
resource "helm_release" "runners" {
  name       = "shopverse-dev-runners"
  namespace  = "arc-runners"
  repository = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart      = "gha-runner-scale-set"
  version    = "0.15.0"

  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [helm_release.controller]
}
