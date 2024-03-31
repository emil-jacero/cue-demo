package flavor

import (
)

#FlavorConfig: common.#ModuleConfig & {
	name:      string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	namespace: *name
	labels: {
		"flavor.emil-jacero.example/name": *name | string,
		...
	}
	apps: {app.#AppConfig, ...}
	bundles: {bundle.#BundleConfig, ...}
}
