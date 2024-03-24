package podinfo

import (
	fluxhelm "github.com/emil-jacero/cue-demo/modules/fluxcd/helm@v0"
)

#Podinfo: fluxhelm.#Helm & {
	spec: {
		name:      "podinfo"
		namespace: "dev-apps"
		repository: {
			url: "https://stefanprodan.github.io/podinfo"
		}
		chart: {
			name: "podinfo"
		}
	}
}
