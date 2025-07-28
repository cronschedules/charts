# CronJob Scale Down Operator Helm Chart

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/cronschedules)](https://artifacthub.io/packages/search?repo=cronschedules)
[![Helm Chart](https://img.shields.io/badge/Helm-Chart-blue)](https://helm.sh/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A Kubernetes operator that automatically scales down Deployments and StatefulSets during specific time windows and cleans up test resources based on annotations and schedules.

## Features

- **🕒 Scheduled Scaling**: Automatically scale down/up resources based on cron schedules
- **🧹 Resource Cleanup**: Clean up test resources based on annotations and time-to-live
- **🌍 Timezone Support**: Configure schedules with specific timezones
- **📊 Metrics & Monitoring**: Built-in Prometheus metrics and health endpoints
- **🔒 Security**: Runs with minimal required permissions and security contexts
- **🎯 Flexible Targeting**: Support for Deployments, StatefulSets, and custom resources

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+

## Installation

### Add Helm Repository

```bash
helm repo add cronschedules https://cronschedules.github.io/charts
helm repo update
```

### Install the Chart

```bash
# Create namespace (recommended)
kubectl create namespace cronschedules-system

# Install with default values
helm install cronjob-scale-down-operator cronschedules/cronjob-scale-down-operator \
  --namespace cronschedules-system

# Install with custom values
helm install cronjob-scale-down-operator cronschedules/cronjob-scale-down-operator \
  --namespace cronschedules-system \
  --set image.tag=0.3.0 \
  --set resources.limits.memory=256Mi
```

## Configuration

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
| `webui.enabled` | Enable web UI | `true` |
| `leaderElection.enabled` | Enable leader election for HA | `true` |

## Usage Examples

### Scheduled Scaling

Scale down a deployment during non-business hours:

```yaml
apiVersion: cronschedules.elbazi.co/v1
kind: CronJobScaleDown
metadata:
  name: webapp-scaler
  namespace: production
spec:
  targetRef:
    name: webapp-deployment
    namespace: production
    kind: Deployment
    apiVersion: apps/v1
  scaleDownSchedule: "0 18 * * 1-5"  # 6 PM on weekdays
  scaleUpSchedule: "0 8 * * 1-5"     # 8 AM on weekdays
  timeZone: "America/New_York"
```

### Resource Cleanup

Clean up test resources older than 2 hours:

```yaml
apiVersion: cronschedules.elbazi.co/v1
kind: CronJobScaleDown
metadata:
  name: test-cleanup
  namespace: testing
spec:
  cleanupSchedule: "0 */2 * * *"  # Every 2 hours
  cleanupConfig:
    annotationKey: "test.elbazi.co/cleanup-after"
    resourceTypes:
      - "Deployment"
      - "Service"
      - "ConfigMap"
      - "Secret"
    labelSelector:
      environment: "test"
    dryRun: false
  timeZone: "UTC"
```

## Monitoring

The operator exposes Prometheus metrics on port 8080:

- `cronjob_scaledown_reconciliations_total` - Total reconciliation attempts
- `cronjob_scaledown_scale_operations_total` - Total scaling operations
- `cronjob_scaledown_cleanup_operations_total` - Total cleanup operations

## Troubleshooting

### Check Operator Logs

```bash
kubectl logs -l control-plane=controller-manager -n cronschedules-system
```

### Verify RBAC Permissions

```bash
kubectl auth can-i list deployments --as=system:serviceaccount:cronschedules-system:cronjob-scale-down-operator
```

### Check CRD Status

```bash
kubectl get cronjobscaledowns -A
kubectl describe cronjobscaledown <name> -n <namespace>
```

## Uninstallation

```bash
helm uninstall cronjob-scale-down-operator -n cronschedules-system
kubectl delete namespace cronschedules-system
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Links

- [Source Code](https://github.com/z4ck404/cronjob-scale-down-operator)
- [Chart Repository](https://github.com/cronschedules/charts)
- [Issues](https://github.com/cronschedules/charts/issues)
- [Artifact Hub](https://artifacthub.io/packages/helm/cronschedules/cronjob-scale-down-operator)
