# Monitoring Helm Configuration

This directory contains Helm dependency definitions used by the GlobalyHub DevOps assessment monitoring stack.

The monitoring stack consists of:

* kube-prometheus-stack

  * Prometheus
  * Grafana
  * Alertmanager
  * Kubernetes monitoring components
* Loki

  * Centralized log storage
* Grafana Alloy

  * Kubernetes log collection
  * Application stdout/stderr collection
  * Metrics collection and forwarding

The monitoring deployments are managed through Argo CD from the GitOps repository.

Environment-specific desired state belongs in the GitOps repository rather than this directory.
