package grafanaoperator

import (
	fluxhelm "github.com/emil-jacero/cue-demo/modules/fluxcd/helm@v0"
)

#GrafanaOperator: fluxhelm.#Helm & {
	spec: {
		name:      *"grafana-operator"
		namespace: *"grafana"
		repository: {
			url: "oci://ghcr.io/grafana/helm-charts/grafana-operator"
		}
		chart: {
			name: "grafana-operator"
		}
	}
}
