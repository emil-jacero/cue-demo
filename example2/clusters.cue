// @if(prod)

package clusters

// import (
// 	"github.com/emil-jacero/cue-demo/apps/podinfo@v0"
// 	"github.com/emil-jacero/cue-demo/apps/grafanaoperator@v0"
// 	"github.com/emil-jacero/cue-demo/apps/prometheus@v0"
// 	"github.com/emil-jacero/cue-demo/apps/alertmanager@v0"
// )


#Podinfo: #Helm & {
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

#Clusters: [Cluster01Prod]

Cluster01Prod: #MyCluster & {
	name:         "cl1"
    role:         "prod"
    domainSuffix: "example.com"
    clusterOverrides: {
        clusterRole: role
    }
    bundles: {"obs-aio": obsAio}
	// apps: {
    //     "podinfo": #Podinfo & {
    //         spec: {
    //             namespace: "podinfo"
    //             serviceAccountName: "flux-apps"
    //             chart: version: "6.0.x"
    //             values: {
    //                 hpa: {
    //                     enabled:     true
    //                     maxReplicas: 10
    //                     cpu:         99
    //                 }
    //                 resources: {
    //                     limits: memory: "512Mi"
    //                     requests: {
    //                         cpu:    "100m"
    //                         memory: "32Mi"
    //                     }
    //                 }
    //             }
    //         }
    //     }
    //     "grafana-operator": grafanaoperator.#GrafanaOperator & {
    //         spec: {
    //             chart: version: "v5.6.3"
    //             values: {
    //                 image: {
    //                     repository: "ghcr.io/grafana/grafana-operator"
    //                     pullPolicy: "Always"
    //                     tag: ""
    //                 }
    //             }
    //         }
    //     }
    //     "prometheus": prometheus.#Prometheus & {
    //         spec: {
    //             chart: version: "25.18.0"
    //             values: {
    //                 configmapReload: {
    //                     prometheus: {
    //                         enabled: true
    //                         name: "configmap-reload"
    //                         image: {
    //                             repository: "quay.io/prometheus-operator/prometheus-config-reloader"
    //                             tag:        "v0.72.0"
    //                             digest:     ""
    //                             pullPolicy: "Always"
    //                         }
    //                     }
    //                 }
    //             }
    //         }
    //     }
    //     "alertmanager": alertmanager.#Alertmanager & {
    //         spec: {
    //             chart: version: "1.10.0"
    //             values: {
    //                 image: {
    //                     repository: "quay.io/prometheus/alertmanager"
    //                     pullPolicy: "Always"
    //                     tag: ""
    //                 }
    //             }
    //         }
    //     }
    // }
}
