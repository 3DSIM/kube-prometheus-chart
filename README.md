# kube-prometheus-chart
Helm chart to monitor a kubernetes cluster created using Rancher

This is basically a fork of the CoreOS team's `kube-prometheus` chart.  See https://github.com/coreos/prometheus-operator/tree/master/helm/kube-prometheus.

# Helm
We are using Helm along with Quay.io to host our Helm charts.  See https://github.com/app-registry/appr-helm-plugin and https://coreos.com/blog/quay-application-registry-for-kubernetes.html.

See https://docs.helm.sh for more about Helm.

# Prerequisites
* [Helm 2.5.1](https://docs.helm.sh/using_helm/#installing-the-helm-client)
    * Run `helm init` prior to any other commands
* Kubernetes 1.4+ with Beta APIs enabled
* [Prometheus Operator 0.0.6](https://github.com/coreos/prometheus-operator/blob/master/helm/prometheus-operator/README.md)
If you haven't installed previously, run:
```
helm repo add opsgoodness http://charts.opsgoodness.com
helm install opsgoodness/prometheus-operator --version 0.0.6 --name po
```
* [Helm Registry plugin](https://github.com/app-registry/appr-helm-plugin)

# Installing this chart
To install with release name `my-release` run:
```
helm registry install quay.io/3dsim/kube-prometheus --name=my-release --set grafana.dataSourceURL=<url of prometheus> --set prometheus.externalUrl=<url of prometheus> --set prometheus.externalLabels.env=<env> --set prometheus.retention=720h
```

For DR add this option:
```
--set prometheus.resources.requests.memory=1000Mi
```

# Upgrading the chart
Currently, the registry plugin doesn't support upgrades.  But Helm does.  So to upgrade an existing release, do the following:
* Make sure no outstanding changes are pending.  (If there are changes, see Developers section below.)
* Clone this repo.
* Make sure your `kubectl` is using the right environment:
```
kubectl config use-context <env>
```
* From root directory run:
```
helm upgrade k8s --set grafana.dataSourceURL=<url of prometheus> --set prometheus.externalUrl=<url of prometheus> --set prometheus.externalLabels.env=<env> --set prometheus.retention=< some duration > --set prometheus.nodeSelector.3dsim\\.com/type=general-purpose --set alertmanager.nodeSelector.3dsim\\.com/type=general-purpose --set grafana.nodeSelector.3dsim\\.com/type=general-purpose .
```
Examples for different environments:
```
kubectl config use-context qa && helm upgrade k8s --set grafana.dataSourceURL=http://prometheus-qa.3dsim.com --set prometheus.externalUrl=http://prometheus-qa.3dsim.com --set prometheus.externalLabels.env=qa --set prometheus.retention=720h --set prometheus.nodeSelector.3dsim\\.com/type=general-purpose --set alertmanager.nodeSelector.3dsim\\.com/type=general-purpose --set grafana.nodeSelector.3dsim\\.com/type=general-purpose --set exporter-kube-state.image.tag=v1.0.0 .

kubectl config use-context prod && helm upgrade k8s --set grafana.dataSourceURL=http://prometheus-prod.3dsim.com --set prometheus.externalUrl=http://prometheus-prod.3dsim.com --set prometheus.externalLabels.env=prod --set prometheus.retention=720h --set prometheus.nodeSelector.3dsim\\.com/type=general-purpose --set alertmanager.nodeSelector.3dsim\\.com/type=general-purpose --set grafana.nodeSelector.3dsim\\.com/type=general-purpose --set exporter-kube-state.image.tag=v1.0.0 .

kubectl config use-context gov && helm upgrade k8s --set grafana.dataSourceURL=http://prometheus-gov.3dsim.com --set prometheus.externalUrl=http://prometheus-gov.3dsim.com --set prometheus.externalLabels.env=gov --set prometheus.retention=720h --set prometheus.nodeSelector.3dsim\\.com/type=general-purpose --set alertmanager.nodeSelector.3dsim\\.com/type=general-purpose --set grafana.nodeSelector.3dsim\\.com/type=general-purpose --set exporter-kube-state.image.tag=v1.0.0 .

kubectl config use-context dr && helm upgrade k8s --set grafana.dataSourceURL=http://prometheus-dr.3dsim.com --set prometheus.externalUrl=http://prometheus-dr.3dsim.com --set prometheus.externalLabels.env=dr --set prometheus.retention=720h --set prometheus.resources.requests.memory=1000Mi --set prometheus.nodeSelector.3dsim\\.com/type=general-purpose --set alertmanager.nodeSelector.3dsim\\.com/type=general-purpose --set grafana.nodeSelector.3dsim\\.com/type=general-purpose --set exporter-kube-state.image.tag=v1.0.0 .
```

# Uninstalling the Chart

To uninstall/delete the my-release deployment:
```
helm delete my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.


# Customizing this chart
See [values.yaml](values.yaml) for configuration options.

Use `--set` syntax to set a value:
```console
helm registry install quay.io/3dsim/kube-prometheus --name=my-release --set resources.limits.cpu=300m
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm registry install quay.io/3dsim/kube-prometheus --name=my-release -f values.yaml
```

# Adding new Grafana dashboards
* Create the dashboard in Grafana UI.
* Export the dashboard as JSON.
* Insert exported JSON in the template below:

```
{
  "dashboard": {
      < Paste exported JSON here >
  },
  "inputs": [
    {
      "name": "DS_PROMETHEUS",
      "pluginId": "prometheus",
      "type": "datasource",
      "value": "prometheus"
    }
  ],
  "overwrite": true
}
```

OR use the `wrap-dashboard.sh` script.

* Add to the `grafana.serverDashboardFiles` field in `values.yaml`

# Developers
If you make changes and want to push a new version to quay.io, do the following...

1.  Bump the version in [Chart.yaml](Chart.yaml).
2.  If you modified the dependencies in `requirements.yaml`, run the following commands to update them.  (Currently dependencies are pushed to quay.io repo, and checked into github.)
```
helm repo add opsgoodness http://charts.opsgoodness.com
helm repo add cloudposse https://charts.cloudposse.com/incubator
rm -rf charts/ appr_charts/ requirements.lock
helm registry dep --overwrite
helm dep build
```
The above steps were taken from [this github comment](https://github.com/app-registry/appr-helm-plugin/issues/3#issuecomment-302701693)
3. Login to quay.io (if you haven't previously)
```
helm registry login -u <your username> quay.io
```
4. Push new version
```
helm registry push --namespace 3dsim quay.io
```

See https://github.com/app-registry/appr-helm-plugin#create-and-push-your-own-chart for more info.

5.  Commit all outstanding changes to github