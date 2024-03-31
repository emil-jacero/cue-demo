// package clusters

// import (
// 	kubernetes "k8s.io/apimachinery/pkg/runtime"
// 	// "github.com/emil-jacero/cue-demo/modules/bundle@v0"
//     // Apps
// 	"github.com/emil-jacero/cue-demo/apps/alertmanager@v0"
// 	"github.com/emil-jacero/cue-demo/apps/grafanaoperator@v0"
// 	"github.com/emil-jacero/cue-demo/apps/prometheus@v0"
// 	"github.com/emil-jacero/cue-demo/apps/cinder_csi@v0"
// 	"github.com/emil-jacero/cue-demo/apps/cilium@v0"
// )

// #BundleConfig: {
// 	name:      string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
// 	namespace: string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
// 	labels: {[string]: string}
// 	apps: {...}
//     ...
// }

// #Bundle: #BundleConfig & {
//     name:      *"bundle-1" | string
// 	namespace: "bundle-\(name)"
// 	labels: {"bundle.example2/name": name}
// 	apps: {...}
// 	resources: [ID=_]:     kubernetes.#Object
//     let _ns = namespace
//     let _labels = labels
//     for ak, av in apps {
//         for rk, rv in av.resources {
//             if rv.kind =~ "HelmRelease" {resources: "\(ak)-\(rk)": spec: targetNamespace: rv.metadata.namespace}
//             if rv.apiVersion =~ "^.*toolkit.fluxcd.io.*" {resources: "\(ak)-\(rk)": metadata: namespace: _ns}
//             resources: "\(ak)-\(rk)": metadata: labels: _labels
//             resources: "\(ak)-\(rk)": rv
//         }
//     }
// }

// // #Alertmanager: #Helm & {
// // 	spec: {
// // 		name:      *"alertmanager" | string
// // 		namespace: *"monitoring" | string
// // 		repository: {
// // 			url: "https://prometheus-community.github.io/helm-charts"
// // 		}
// // 		chart: {
// // 			name: "alertmanager"
// // 		}
// // 	}
// // }

// // #GrafanaOperator: #Helm & {
// // 	spec: {
// // 		name:      *"grafana-operator" | string
// // 		namespace: *"grafana" | string
// // 		repository: {
// // 			url: "oci://ghcr.io/grafana/helm-charts/grafana-operator"
// // 		}
// // 		chart: {
// // 			name: "grafana-operator"
// // 		}
// // 	}
// // }

// // #Prometheus: #Helm & {
// // 	spec: {
// // 		name:      *"prometheus" | string
// // 		namespace: *"monitoring" | string
// // 		repository: {
// // 			url: "https://prometheus-community.github.io/helm-charts"
// // 		}
// // 		chart: {
// // 			name: "prometheus"
// // 		}
// // 	}
// // }

// // ObsAio
// ObsAio: #Bundle & {
//     name: "obs-aio"
//     apps: {
//         "grafana-operator": grafanaoperator.#GrafanaOperator & {
//             spec: {
//                 chart: version: "v5.6.3"
//                 values: {
//                     image: {
//                         repository: "ghcr.io/grafana/grafana-operator"
//                         pullPolicy: "Always"
//                         tag: ""
//                     }
//                 }
//             }
//         }
//         "prometheus": prometheus.#Prometheus & {
//             spec: {
//                 chart: version: "25.18.0"
//                 values: {
//                     configmapReload: {
//                         prometheus: {
//                             enabled: true
//                             name: "configmap-reload"
//                             image: {
//                                 repository: "quay.io/prometheus-operator/prometheus-config-reloader"
//                                 tag:        "v0.72.0"
//                                 digest:     ""
//                                 pullPolicy: "Always"
//                             }
//                         }
//                     }
//                 }
//             }
//         }
//         "alertmanager": alertmanager.#Alertmanager & {
//             spec: {
//                 chart: version: "1.10.0"
//                 values: {
//                     image: {
//                         repository: "quay.io/prometheus/alertmanager"
//                         pullPolicy: "Always"
//                         tag: ""
//                     }
//                 }
//             }
//         }
//     }
// }

// // NetCilium
// NetCilium: #Bundle & {
//     name: "net-cilium"
//     apps: {
//         "cilium": cilium.#Cilium & {
//             spec: {
//                 chart: version: "1.16.0-pre.0"
//                 values: {
//                     MTU: 0
//                     authentication: enabled: true
//                     hubble: enabled: true
//                     hubble: ui: ingress: {
//                         enabled: true
//                         annotations: {}
//                         labels: {}
//                         className: "nginx"
//                         hosts: ["chart-example.local"]
//                         tls: []
//                         }
//                 }
//             }
//         }
//     }
// }

// // StorO7k
// StorO7k: #Bundle & {
//     name: "stor-o7k"
//     apps: {
//         "cinder-csi": cinder_csi.#CinderCsi & {
//             spec: {
//                 chart: version: "2.29.0"
//                 values: {
//                     secret: {
//                         enabled:   true
//                         hostMount: true
//                         create:    true
//                         filename:  "cloud.conf"
//                         name:      "cinder-csi-cloud-config"
//                         data: "cloud.conf": """
//                             [Global]
//                             auth-url=http://openstack-control-plane
//                             user-id=user-id
//                             password=password
//                             trust-id=trust-id
//                             region=RegionOne
//                             ca-file=/etc/cacert/ca-bundle.crt
//                             """
//                     }
//                     storageClass: {
//                         enabled: true
//                         delete: {
//                             isDefault:            false
//                             allowVolumeExpansion: true
//                         }
//                         retain: {
//                             isDefault:            true
//                             allowVolumeExpansion: true
//                         }
//                     }
//                 }
//             }
//         }
//     }
// }
