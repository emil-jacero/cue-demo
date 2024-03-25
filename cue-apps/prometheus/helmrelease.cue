package prometheus

import (
	fluxhelm "github.com/emil-jacero/cue-demo/modules/fluxcd/helm@v0"
)

#Prometheus: fluxhelm.#Helm & {
	spec: {
		name:      "prometheus"
		namespace: "monitoring"
		repository: {
			url: "https://prometheus-community.github.io/helm-charts"
		}
		chart: {
			name: "prometheus"
		}
	}
}
