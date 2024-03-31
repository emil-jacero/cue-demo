package alertmanager

import (
	fluxhelm "github.com/emil-jacero/cue-demo/modules/fluxcd/helm@v0"
)

#Alertmanager: fluxhelm.#Helm & {
	spec: {
		name:      *"alertmanager" | string
		namespace: *"monitoring" | string
		repository: {
			url: "https://prometheus-community.github.io/helm-charts"
		}
		chart: {
			name: "alertmanager"
		}
	}
}
