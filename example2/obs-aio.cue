package clusters

import (
	"github.com/emil-jacero/cue-demo/modules/bundle@v0"
    // Apps
	// "github.com/emil-jacero/cue-demo/apps/alertmanager@v0"
	// "github.com/emil-jacero/cue-demo/apps/grafanaoperator@v0"
	// "github.com/emil-jacero/cue-demo/apps/prometheus@v0"
)

#Alertmanager: #Helm & {
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

#GrafanaOperator: #Helm & {
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



#Prometheus: #Helm & {
	spec: {
		name:      *"prometheus" | string
		namespace: *"monitoring" | string
		repository: {
			url: "https://prometheus-community.github.io/helm-charts"
		}
		chart: {
			name: "prometheus"
		}
	}
}

ObsAio: bundle.#Bundle & {
    name: "obs-aio"
    apps: {
        "grafana-operator": grafanaoperator.#GrafanaOperator & {
            spec: {
                chart: version: "v5.6.3"
                values: {
                    image: {
                        repository: "ghcr.io/grafana/grafana-operator"
                        pullPolicy: "Always"
                        tag: ""
                    }
                }
            }
        }
        "prometheus": prometheus.#Prometheus & {
            spec: {
                chart: version: "25.18.0"
                values: {
                    configmapReload: {
                        prometheus: {
                            enabled: true
                            name: "configmap-reload"
                            image: {
                                repository: "quay.io/prometheus-operator/prometheus-config-reloader"
                                tag:        "v0.72.0"
                                digest:     ""
                                pullPolicy: "Always"
                            }
                        }
                    }
                }
            }
        }
        "alertmanager": alertmanager.#Alertmanager & {
            spec: {
                chart: version: "1.10.0"
                values: {
                    image: {
                        repository: "quay.io/prometheus/alertmanager"
                        pullPolicy: "Always"
                        tag: ""
                    }
                }
            }
        }
    }
}
