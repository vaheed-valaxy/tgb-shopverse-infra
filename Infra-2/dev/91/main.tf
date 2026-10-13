resource "helm_release" "controller" {
  name       = "arc"
  namespace  = "arc-system"
  repository = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart      = "gha-runner-scale-set-controller"

  create_namespace = true
}

resource "kubernetes_namespace" "runners" {
  metadata {
    name = "arc-runners"
  }
}

resource "kubernetes_service_account" "runner" {
  metadata {
    name      = "github-runner"
    namespace = "arc-runners"
    annotations = {
      "eks.amazonaws.com/role-arn" = var.runner_role_arn
    }
  }
}

resource "helm_release" "runners" {
  name       = "arc-runners"
  namespace  = "arc-runners"
  repository = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart      = "gha-runner-scale-set"

  create_namespace = true

  values = [
    yamlencode({
      githubConfigUrl = "https://github.com/${var.github_org}/${var.github_repo}"

      githubConfigSecret = {
        github_token = var.github_token
      }

      runnerScaleSetName = "k8s-runners"

      template = {
        spec = {
          serviceAccountName = "github-runner"
        }
      }
    })
  ]
}
