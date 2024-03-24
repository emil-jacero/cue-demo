package flavor

import (
	common "github.com/emil-jacero/cue-demo/modules/common@v0"
	app "github.com/emil-jacero/cue-demo/modules/app@v0"
	bundle "github.com/emil-jacero/cue-demo/modules/bundle@v0"
)

#FlavorConfig: common.#Config & {
	name:      string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	namespace: *name
	labels: {
		"flavor.emil-jacero.example/name": *name | string,
		...
	}
	apps: {app.#AppConfig, ...}
	bundles: {bundle.#BundleConfig, ...}
}
