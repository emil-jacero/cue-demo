// @if(prod)

package clusters

import (
    "github.com/emil-jacero/cue-demo/apps/podinfo@v0"
    "github.com/emil-jacero/cue-demo/bundles/obs_aio@v0"
    "github.com/emil-jacero/cue-demo/bundles/net_cilium@v0"
    "github.com/emil-jacero/cue-demo/bundles/stor_o7k@v0"
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
    }
    bundles: {
        "obs-aio": obs_aio.ObsAio
        "net-cilium": net_cilium.NetCilium
        "stor-o7k": stor_o7k.StorO7k
    }
}
