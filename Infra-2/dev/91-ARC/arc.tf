
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
# ARC Runner Namespace
# -------------------------------------------------------
resource "kubernetes_namespace" "runners" {
  metadata {
    name = "arc-runners"
  }
}

# -------------------------------------------------------
# ARC Runner Scale Set
# -------------------------------------------------------
resource "helm_release" "runners" {
  name       = "shopverse-dev-runners"
  namespace  = kubernetes_namespace.runners.metadata[0].name
  repository = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart      = "gha-runner-scale-set"
  version    = "0.15.0"

  create_namespace = false

  values = [
    yamlencode({
      # GitHub repository used by ARC
      githubConfigUrl = "https://github.com/${var.github_org}/${var.github_repo}"

      # Existing Kubernetes Secret in arc-runners
      githubConfigSecret = "shopverse-github-token"

      # Runner scale set configuration
      runnerScaleSetName = "shopverse-dev-runners"
      minRunners         = 1
      maxRunners         = 3

      # Explicitly identify the ARC controller ServiceAccount
      controllerServiceAccount = {
        namespace = "arc-systems"
        name      = "arc-controller-gha-rs-controller"
      }

      # Enable Docker-in-Docker for Docker builds
      containerMode = {
        type = "dind"
      }

      # Attach the ECR IAM role to the chart-generated runner ServiceAccount
      resourceMeta = {
        noPermissionServiceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = var.runner_role_arn
          }
        }
      }
    })
  ]

  depends_on = [
    helm_release.controller,
    kubernetes_namespace.runners
  ]
}
