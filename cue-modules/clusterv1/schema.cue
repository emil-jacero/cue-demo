package cluster

import (
	common "github.com/emil-jacero/cue-demo/modules/common@v0"
	app "github.com/emil-jacero/cue-demo/modules/app@v0"
	bundle "github.com/emil-jacero/cue-demo/modules/bundle@v0"
	flavor "github.com/emil-jacero/cue-demo/modules/flavor@v0"
    fluxhelm "github.com/emil-jacero/cue-demo/modules/fluxcd/helm@v0"
)

#ClusterOverrides: {
    clusterName:   string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
    clusterFQDN:   string & =~"^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9](?:\\.[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9])+$"
    clusterlabels: {[string]: string}
    ...
}

#ClusterConfig: {
	name:         string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
    domainSuffix: string & =~"^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9](?:\\.[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9])+$"
    labels:     {[string]: string}
    clusterOverrides: #ClusterOverrides
	apps?: {app.#AppConfig, ...}
	bundles?: {bundle.#BundleConfig, ...}
    flavor?: flavor.#FlavorConfig
    ...
}
