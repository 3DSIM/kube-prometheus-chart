# kube-prometheus-chart
Helm chart to monitor a kubernetes cluster created using Rancher

This is basically a fork of the CoreOS team's `kube-prometheus` chart.  See https://github.com/coreos/prometheus-operator/tree/master/helm/kube-prometheus.

# Helm
We are using Helm along with Quay.io to host our Helm charts.  See https://github.com/app-registry/appr-helm-plugin and https://coreos.com/blog/quay-application-registry-for-kubernetes.html.

See https://docs.helm.sh for more about Helm.

# Prerequisites
* Kubernetes 1.4+ with Beta APIs enabled
* [Helm Registry plugin](https://github.com/app-registry/appr-helm-plugin)

# Installing this chart
To install with release name `my-release` run:
```
helm registry install quay.io/3dsim/node-exporter --name=my-release --set grafana.dataSourceURL=<url of prometheus>
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
helm registry install quay.io/3dsim/node-exporter --name=my-release --set resources.limits.cpu=300m
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm registry install quay.io/3dsim/node-exporter --name=my-release -f values.yaml
```

# Developers
If you make changes and want to push a new version to quay.io, do the following...

1.  Bump the version in [Chart.yaml](Chart.yaml).
2.  Commit all outstanding changes to github
3.  If you  modified the dependencies in `requirements.yaml`, run the following commands to update them.  (Currently dependencies are pushed to quay.io repo, but not checked into github.)
```
helm registry dep --overwrite
helm dep build
```
The above steps were taken from [this github comment](https://github.com/app-registry/appr-helm-plugin/issues/3#issuecomment-302701693)
4. Login to quay.io (if you haven't previously)
```
helm registry login -u <your username> quay.io
```
5. Push new version
```
helm registry push --namespace 3dsim quay.io
```

See https://github.com/app-registry/appr-helm-plugin#create-and-push-your-own-chart for more info.

6. Revert `requirements.yaml` changes.  (The `registry` plugin for helm modified the file.  We do not want to check them in.)
