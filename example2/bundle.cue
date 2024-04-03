package clusters

import (
	kubernetes "k8s.io/apimachinery/pkg/runtime"
	// "github.com/emil-jacero/cue-demo/modules/bundle@v0"
    // Apps
	// "github.com/emil-jacero/cue-demo/apps/alertmanager@v0"
	// "github.com/emil-jacero/cue-demo/apps/grafanaoperator@v0"
	// "github.com/emil-jacero/cue-demo/apps/prometheus@v0"
	// "github.com/emil-jacero/cue-demo/apps/cinder_csi@v0"
	// "github.com/emil-jacero/cue-demo/apps/cilium@v0"
)

#BundleConfig: {
	name:      string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	namespace: string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	labels: {[string]: string}
	apps: {...}
    ...
}

#Bundle: #BundleConfig & {
    name:      *"example-1" | string
	namespace: "bundle-\(name)"
	labels: {"bundle.example/name": name}
	apps: {...}
	resources: [ID=_]:     kubernetes.#Object
    let _ns = namespace
    let _labels = labels
    for ak, av in apps {
        for rk, rv in av.resources {
            if rv.kind =~ "HelmRelease" {resources: "\(ak)-\(rk)": spec: targetNamespace: rv.metadata.namespace}
            if rv.apiVersion =~ "^.*toolkit.fluxcd.io.*" {resources: "\(ak)-\(rk)": metadata: namespace: _ns}
            resources: "\(ak)-\(rk)": metadata: labels: _labels
            resources: "\(ak)-\(rk)": rv
        }
    }
}
