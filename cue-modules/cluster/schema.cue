package cluster

import (
	common "github.com/emil-jacero/cue-demo/modules/common@v0"
	app "github.com/emil-jacero/cue-demo/modules/app@v0"
	bundle "github.com/emil-jacero/cue-demo/modules/bundle@v0"
	flavor "github.com/emil-jacero/cue-demo/modules/flavor@v0"
)

#ClusterConfig: {
	name:         string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
    role:         string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$",
    domainSuffix: string & =~"^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9](?:\.[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9])+$",
    metadata:     {string, string}

    globalValues: {
        clusterName:         name,
        clusterRole:         role,
        clusterPublicDomain: string & =~"^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9](?:\.[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9])+$",
        ...
    }

	apps: {app.#AppConfig, ...}
	bundles: {bundle.#BundleConfig, ...}
    flavors: {flavor.#FlavorConfig, ...}
}