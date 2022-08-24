provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}


resource "datadog_monitor" "beacon" {
  name               = "Kubernetes Pod Health"
  type               = "metric alert"
  message            = "Kubernetes Pods are not in an optimal health state. Notify: @operator"
  escalation_message = "Please investigate the Kubernetes Pods, @operator"
  query = "max(last_10m):max:kubernetes_state.container.status_report.count.waiting{reason:imagepullbackoff} by {kube_namespace,pod_name} >= 1"
  notify_no_data = true

 monitor_thresholds {
    critical = 1
  }


  tags = ["app:beacon", "env:demo"]

}

