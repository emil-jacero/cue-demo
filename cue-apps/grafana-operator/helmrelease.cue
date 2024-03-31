package grafanaoperator

import (
	fluxhelm "github.com/emil-jacero/cue-demo/modules/fluxcd/helm@v0"
)

#GrafanaOperator: fluxhelm.#Helm & {
	spec: {
		name:      *"grafana-operator" | string
		namespace: *"grafana" | string
		repository: {
			url: "oci://ghcr.io/grafana/helm-charts/grafana-operator"
		}
		chart: {
			name: "grafana-operator"
		}
	}
}
