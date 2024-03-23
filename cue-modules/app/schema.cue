package app

import (
	common "github.com/emil-jacero/cue-demo/common@v0"
)

#AppConfig: common.#Config & {
	name:      string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	namespace: *name
	labels: {
		"app.emil-jacero.example/name": *name | string,
		...
	}
}
