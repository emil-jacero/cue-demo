package podinfo

import (
	fluxhelm "github.com/emil-jacero/cue-demo/modules/fluxcd/helm@v0"
)

#Podinfo: fluxhelm.#Helm & {
	spec: {
		name:      *"podinfo" | string
		namespace: *"dev-apps" | string
		repository: {
			url: "https://stefanprodan.github.io/podinfo"
		}
		chart: {
			name: "podinfo"
		}
	}
}
