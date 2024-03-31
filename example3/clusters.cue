// @if(prod)

package clusters

import (
    "github.com/emil-jacero/cue-demo/bundles/obs-aio@v0"
)

#Clusters: [Cluster01Prod]

Cluster01Prod: #MyCluster & {
	name:         "cl1"
    role:         "prod"
    domainSuffix: "example.com"
    clusterOverrides: {
        clusterRole: role
    }
    bundles: {"obs-aio": obsAio}
}
