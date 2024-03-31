package net_cilium

import (
	"github.com/emil-jacero/cue-demo/modules/bundle@v0"
    // Apps
	"github.com/emil-jacero/cue-demo/apps/cilium@v0"
)

NetCilium: bundle.#Bundle & {
    name: "net-cilium"
    apps: {
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
    }
}
