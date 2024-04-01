# Cue Demo

This demo borrows heavily from the work of the [fluxcd](https://github.com/fluxcd/cues) team.
I specifically borrowed the release schema and template and reimplemented my own for the kustomizations.

NOTE: I have not implemented any SOPS support or similar. I don't think it is relevant for these examples.

## Description

This demo is designed to showcase a more advanced use-case of CUE and Kubernetes.

You will setup a few CUE modules that have the purpose of including the schemas of core components like the k8s api and fluxcd. Then you will add the `apps`, `bundles` and `flavors` as modules as well.

The demo will also introduce another module type that is called `cluster`.

### Apps

Apps are the smallest component meant to be a single deployment like `grafana-operator`. Due to the heavy reliance on helm-charts we have to use flux helmreleases for now, but they are still packaged as an `app`.

The purpose of the app is to only contain the bare minimum for the deployment. Meaning, when deploying the app, outside a bundle, the app does not necessary have to deploy correctly. An example would be a single helm chart.

### Bundles

Bundles contain multiple `apps` and configuration to tie them together into a single deployable unit. This concept is borrowed from the [Timoni](https://timoni.sh/bundle/) project.
*I have another demo showcasing the same pattern but utilizing Timoni instead of only CUE [here](https://github.com/emil-jacero/timoni-demo)*

For example, a bundle could be named `observability-aio` (all-in-one). This is a full stack deployment for monitoring and logging (in my example only monitoring is included). The configuration set in the bundle is meant to be a sane default and should be deployable as a whole unit to a cluster.

The bundles also depend on the `clusterOverrides` from the cluster cue module. This override function is designed to be a bit opinionated but can be extended by the user.

A override could be `clusterFQDN`. Add this as a default `*clusterFQDN | string` to the ingress of each application in the bundle and it would be set to `example.com` if not overridden by the cluster operator.

The override value in this case is `example.com` meaning an ingress could be "automagically" set to `podinfo.example.com`, simplifying the work of the operator.

### Flavors

The flavor is meant to gather multiple `apps` and `bundles` and maybe include some overrides as well. The difference between a bundle and a flavor is that the flavor creates a single configuration for a whole cluster that can be shared among multiple clusters, with ease.

A cluster operator responsible for hundreds of clusters can create a few opinionated flavors that are tested and could be rolled out more safely and also making the life of the operator much easier.

Because the point of a flavor is to be opinionated and reused by multiple cluster we can only allow a single flavor per cluster, but a flavor can depend on another flavor.

### Cluster

The cluster type is a specialized configuration that must include app/s, bundle/s or a flavor. The cluster configuration contains global variables like the cluster specific domain name (eg. `cl1.prod.example.com`).

When building the cluster configuration all the configuration from the apps, bundles and flavor is combined with the global variables into the output yaml.

The resulting output can be pushed to a git repo, or even better, to be packaged as an OCI artifact and pushed to a OCI registry.

## Dependencies

- go == 1.21.0
- CUE == 0.8.0

## Examples

First set the working dir. This should be the root of the git repo!

```shell
export WDIR=$(pwd)
```

Enable the experimental cue modules support.

```shell
export CUE_EXPERIMENT=modules
```

Set the OCI registry URL.

```shell
export CUE_REGISTRY=localhost:5000/cue-demo
```

### Registry

Pull and run a docker registry.

```shell
docker run -d -p 5000:5000 --restart always --name registry registry:2
```

Destroy registry to cleanup.

```shell
docker rm -f reg
```

### Example1

This example aims to showcase the way `apps` are defined and how clusters are defined.

The cluster operator can define a set of apps with the value overrides.
The apps will be unpacked and exported as yaml kubernetes manifests.

Go to the [README](example1/README.md)

### Example2

This examples used the built in module function to both get schemas and templates to render correct kubernetes manifest. It also uses the same delivery method (cue modules) to define `apps` and `bundles`

Go to the [README](example2/README.md)

### Example3

This example showcases `flavors`. Flavors are a meant to be opinionated towards a specific deployment stack. For example, a flavor could be written and maintained to be ran only on OpenStack. The person maintaining the flavor adds the specific bundles and apps that are required for that deployment.

This is a powerful feature for the Enterprise which still works with a central IT organization.

Go to the [README](example3/README.md)

## Developing your own app

### Preparations

Download go modules.
(These modules can later be used to generate CUE schemas)

```shell
export GO111MODULE=off
go get -d k8s.io/api/core/v1
go get -d k8s.io/api/apps/v1
go get -d k8s.io/api/networking/v1
go get -d k8s.io/apimachinery
go get -d k8s.io/apiextensions-apiserver
```

Optional: Generate cue schema from go modules

```shell
cue get go k8s.io/api/core/v1
cue get go k8s.io/api/apps/v1
cue get go k8s.io/api/networking/v1
cue get go k8s.io/apimachinery/pkg/apis/meta/v1
cue get go k8s.io/apiextensions-apiserver/pkg/apis/apiextensions/v1
```
