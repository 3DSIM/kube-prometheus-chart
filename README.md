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
helm registry install quay.io/3dsim/kube-prometheus --name=my-release --set grafana.dataSourceURL=<url of prometheus> --set prometheus.externalUrl=<url of prometheus> --set prometheus.externalLabels.env=<env>
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

# Developers
If you make changes and want to push a new version to quay.io, do the following...

1.  Bump the version in [Chart.yaml](Chart.yaml).
2.  If you modified the dependencies in `requirements.yaml`, run the following commands to update them.  (Currently dependencies are pushed to quay.io repo, and checked into github.)
```
helm repo add opsgoodness http://charts.opsgoodness.com
helm repo add cloudposse https://charts.cloudposse.com/incubator
rm -rf charts/ appr_charts/
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