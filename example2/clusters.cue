// @if(prod)

package clusters

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
