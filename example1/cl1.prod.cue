// @if(prod)

package clusters

import (
	// fluxhelm "github.com/emil-jacero/cue-demo/modules/fluxcd/helm@v0"
	cluster "github.com/emil-jacero/cue-demo/modules/cluster@v0"
	apppodinfo "github.com/emil-jacero/cue-demo/apps/podinfo@v0"
)

#Clusters: [Cluster01]

#clusterOverrides: cluster.#ClusterOverrides & {
    clusterName: "cl1"
    clusterRole: "prod"
}

Cluster01: cluster.#Cluster & {
	name:         "cl1"
    role:         "prod"
    domainSuffix: "example.com"
    clusterOverrides: #clusterOverrides
	apps: {
        podinfo: apppodinfo.#Podinfo & {
            spec: {
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
    }
}
