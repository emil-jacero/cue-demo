package alertmanager

import (
	fluxhelm "github.com/emil-jacero/cue-demo/modules/fluxcd/helm@v0"
)

#Alertmanager: fluxhelm.#Helm & {
	spec: {
		name:      "alertmanager"
		namespace: "monitoring"
		repository: {
			url: "https://prometheus-community.github.io/helm-charts"
		}
		chart: {
			name: "alertmanager"
		}
	}
}
