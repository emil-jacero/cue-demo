package cilium

import (
	fluxhelm "github.com/emil-jacero/cue-demo/modules/fluxcd/helm@v0"
)

#Cilium: fluxhelm.#Helm & {
	spec: {
		name:      *"cilium" | string
		namespace: *"cilium" | string
		repository: {
			url: "https://helm.cilium.io/"
		}
		chart: {
			name: "cilium"
		}
	}
}
