package app

import (
	common "github.com/emil-jacero/cue-demo/modules/common@v0"
)

#AppConfig: common.#ModuleConfig & {
	name:      string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	namespace: *"app-\(name)"
	labels: {
		"app.emil-jacero.example/name": *name | string,
		...
	}
}
