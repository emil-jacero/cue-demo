// @if(prod)

package clusters

import (
    "github.com/emil-jacero/cue-demo/apps/podinfo@v0"
    "github.com/emil-jacero/cue-demo/apps/alertmanager@v0"
    "github.com/emil-jacero/cue-demo/apps/cilium@v0"
    "github.com/emil-jacero/cue-demo/apps/cinder_csi@v0"
    "github.com/emil-jacero/cue-demo/apps/grafanaoperator@v0"
    "github.com/emil-jacero/cue-demo/apps/prometheus@v0"
)

#Clusters: [Cluster01Prod]

Cluster01Prod: #MyCluster & {
	name:         "cl1"
    role:         "prod"
    domainSuffix: "example.com"
    clusterOverrides: {
        clusterRole: role
    }
    apps: {
        "podinfo": podinfo.#Podinfo & {
            spec: {
                namespace: "podinfo"
                serviceAccountName: "flux-apps"
                chart: version: "6.0.x"
                values: {
                    hpa: {
                        enabled:     true
                        maxReplicas: 10
                        cpu:         99
                    }
                    resources: {
                        limits: memory: "512Mi"
                        requests: {
                            cpu:    "100m"
                            memory: "32Mi"
                        }
                    }
                }
            }
        }
        "cilium": cilium.#Cilium & {
            spec: {
                chart: version: "1.16.0-pre.0"
                values: {
                    MTU: 0
                    authentication: enabled: true
                    hubble: enabled: true
                    hubble: ui: ingress: {
                        enabled: true
                        annotations: {}
                        labels: {}
                        className: "nginx"
                        hosts: ["chart-example.local"]
                        tls: []
                        }
                }
            }
        }
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
        "cinder-csi": cinder_csi.#CinderCsi & {
            spec: {
                chart: version: "2.29.0"
                values: {
                    secret: {
                        enabled:   true
                        hostMount: true
                        create:    true
                        filename:  "cloud.conf"
                        name:      "cinder-csi-cloud-config"
                        data: "cloud.conf": """
                            [Global]
                            auth-url=http://openstack-control-plane
                            user-id=user-id
                            password=password
                            trust-id=trust-id
                            region=RegionOne
                            ca-file=/etc/cacert/ca-bundle.crt
                            """
                    }
                    storageClass: {
                        enabled: true
                        delete: {
                            isDefault:            false
                            allowVolumeExpansion: true
                        }
                        retain: {
                            isDefault:            true
                            allowVolumeExpansion: true
                        }
                    }
                }
            }
        }
    }
}
