# ----------------------------------------------------------
# ARC Runner Namespace
# ----------------------------------------------------------

resource "kubernetes_namespace_v1" "arc_runners" {
  metadata {
    name = "arc-runners"

    labels = {
      "app.kubernetes.io/part-of" = var.project
      "environment"               = var.env
    }
  }
}

# ----------------------------------------------------------
# ARC Runner Service Account
# ----------------------------------------------------------

resource "kubernetes_service_account_v1" "backend_runner" {
  metadata {
    name      = "shopverse-gha-arc-runner-sa"
    namespace = kubernetes_namespace_v1.arc_runners.metadata[0].name

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.gha_arc_runner_role.arn
    }
  }
}
