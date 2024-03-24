package cluster

import (
	// common "github.com/emil-jacero/cue-demo/modules/common@v0"
	// app "github.com/emil-jacero/cue-demo/modules/app@v0"
	// bundle "github.com/emil-jacero/cue-demo/modules/bundle@v0"
	// flavor "github.com/emil-jacero/cue-demo/modules/flavor@v0"
    // fluxhelm "github.com/emil-jacero/cue-demo/modules/fluxcd/helm@v0"
)

#DomainValidator: string & =~"^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9](?:\\.[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9])+$"
#NameValidator: string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"

#ClusterOverrides: {
    clusterName:   string
    clusterRole:   string
    clusterFQDN:   string
    clusterlabels: {[string]: string}
    ...
}

#ClusterConfig: {
	name:         string
    role:         string
    domainSuffix: string
    labels:     {[string]: string}
    clusterOverrides: #ClusterOverrides
    apps: {...}
	// apps: {app.#AppConfig, ...}
	// bundles: {bundle.#BundleConfig, ...}
    // flavor: flavor.#FlavorConfig
}
