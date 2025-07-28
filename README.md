# CronSchedules Charts Repository

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/cronschedules)](https://artifacthub.io/packages/search?repo=cronschedules)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

This repository contains Helm charts for various CronJob and scheduling-related Kubernetes operators and applications.

## Charts

### CronJob Scale Down Operator

This chart installs the CronJob Scale Down Operator on a Kubernetes cluster using the Helm package manager.

The operator provides two main features:
1. **Automatic Scaling**: Scale down Deployments and StatefulSets during specific time windows
2. **Resource Cleanup**: Automatically clean up test resources based on annotations and schedules

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+

## Installation

### Add Helm Repository

```bash
helm repo add cronschedules https://cronschedules.github.io/charts
helm repo update
```

📦 **Also available on [Artifact Hub](https://artifacthub.io/packages/search?repo=cronschedules)**

### Install Chart

```bash
# Install the chart
helm install cronjob-scale-down-operator cronschedules/cronjob-scale-down-operator
```

### Install from Local Chart

```bash
# Clone the repository
git clone https://github.com/cronschedules/charts.git
cd charts

# Install the chart
helm install cronjob-scale-down-operator ./cronjob-scale-down-operator
```

### Install with Custom Values

```bash
helm install cronjob-scale-down-operator cronschedules/cronjob-scale-down-operator \
  --set image.tag=0.3.0 \
  --set resources.requests.memory=128Mi
```

## Testing

This chart includes comprehensive testing using [chart-testing](https://github.com/helm/chart-testing) and GitHub Actions.

### Local Testing

Run the included test script to validate the chart locally:

```bash
./scripts/test-chart.sh
```

### CI Test Values

The chart is tested with multiple configuration scenarios:
- **`ci/testing-values.yaml`**: CI-optimized configuration with reduced resources
- **`ci/default-values.yaml`**: Standard production-like settings
- **`ci/minimal-values.yaml`**: Minimal resource allocation
- **`ci/ha-values.yaml`**: High availability configuration

## Chart Testing

This repository uses [chart-testing](https://github.com/helm/chart-testing) and GitHub Actions for comprehensive chart validation.

## Configuration

The following table lists the configurable parameters and their default values:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of operator replicas | `1` |
| `image.repository` | Container image repository | `cronschedules/z4ck404/cronjob-scale-down-operator` |
| `image.tag` | Container image tag | `0.3.0` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `serviceAccount.create` | Create service account | `true` |
| `rbac.create` | Create RBAC resources | `true` |
| `resources.limits.cpu` | CPU limit | `500m` |
| `resources.limits.memory` | Memory limit | `128Mi` |
| `resources.requests.cpu` | CPU request | `10m` |
| `resources.requests.memory` | Memory request | `64Mi` |
| `metrics.enabled` | Enable metrics service | `true` |
| `leaderElection.enabled` | Enable leader election | `true` |

## Usage

After installation, you can create CronJobScaleDown resources for different use cases:

### Automatic Scaling

Scale down resources during specific time windows:

```yaml
apiVersion: cronschedules.elbazi.co/v1
kind: CronJobScaleDown
metadata:
  name: my-scaler
  namespace: default
spec:
  targetRef:
    name: my-deployment
    namespace: default
    kind: Deployment
    apiVersion: apps/v1
  scaleDownSchedule: "0 0 22 * * *"  # 10 PM daily
  scaleUpSchedule: "0 0 6 * * *"     # 6 AM daily
  timeZone: "UTC"
```

### Resource Cleanup Only

Clean up test resources based on annotations:

```yaml
apiVersion: cronschedules.elbazi.co/v1
kind: CronJobScaleDown
metadata:
  name: cleanup-only
  namespace: default
spec:
  cleanupSchedule: "0 0 */6 * * *"    # Every 6 hours
  cleanupConfig:
    annotationKey: "test.elbazi.co/cleanup-after"
    resourceTypes:
      - "Deployment"
      - "Service"
      - "ConfigMap"
    labelSelector:
      app.kubernetes.io/created-by: "test"
    dryRun: true  # Set to false to actually delete resources
  timeZone: "UTC"
```

### Combined Scaling and Cleanup

Use both features in one resource:

```yaml
apiVersion: cronschedules.elbazi.co/v1
kind: CronJobScaleDown
metadata:
  name: combined-example
  namespace: default
spec:
  targetRef:
    name: my-deployment
    namespace: default
    kind: Deployment
  scaleDownSchedule: "0 0 22 * * *"  # 10 PM daily
  scaleUpSchedule: "0 0 6 * * *"     # 6 AM daily
  cleanupSchedule: "0 0 2 * * *"     # 2 AM daily
  cleanupConfig:
    annotationKey: "test.elbazi.co/cleanup-after"
    resourceTypes: ["ConfigMap", "Secret"]
    dryRun: false
  timeZone: "UTC"
```

## Uninstallation

```bash
helm uninstall cronjob-scale-down-operator
```

## Development

To render templates locally:

```bash
helm template cronjob-scale-down-operator ./cronjob-scale-down-operator
```

To validate the chart:

```bash
helm lint ./cronjob-scale-down-operator
```
