package bundle

import (
	common "github.com/emil-jacero/cue-demo/modules/common@v0"
	app "github.com/emil-jacero/cue-demo/modules/app@v0"
)

#BundleConfig: common.#ModuleConfig & {
	name:      string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	namespace: *"bundle-\(name)" | string
	labels: {
		"bundle.emil-jacero.example/name": *name | string,
		...
	}
	apps: {app.#AppConfig, ...}
}
