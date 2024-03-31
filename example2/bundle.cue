package clusters

import (
	kubernetes "k8s.io/apimachinery/pkg/runtime"
	// common "github.com/emil-jacero/cue-demo/modules/common@v0"
)

#BundleConfig: {
	name:      string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	namespace: string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	// labels: {
	// 	"bundle.emil-jacero.example/name": *name | string,
	// 	...
	// }
	apps: {...}
    ...
}

#Bundle: #BundleConfig & {
    name:      *"bundle-1" | string
	namespace: "bundle-\(name)"
	apps: {...}
	resources: [ID=_]:     kubernetes.#Object
    let _ns = namespace
    for ak, av in apps {
        for rk, rv in av.resources {
            if rv.apiVersion =~ "^helm.toolkit.fluxcd.io.*" {resources: "\(ak)-\(rk)": targetNamespace: rv.metadata.namespace}
            if rv.apiVersion =~ "^helm.toolkit.fluxcd.io.*" {resources: "\(ak)-\(rk)": metadata: namespace: _ns}
            resources: "\(ak)-\(rk)": rv
        }
    }
}

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

obsAio: #Bundle & {
    name: "obs-aio"
    apps: {
        "grafana-operator": #GrafanaOperator & {
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
        "prometheus": #Prometheus & {
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
        "alertmanager": #Alertmanager & {
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
