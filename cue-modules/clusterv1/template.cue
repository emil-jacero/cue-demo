package cluster

#Cluster: #ClusterConfig & {
	name:          *"cluster01" | string
    domainSuffix:  *"example.com" | string
    labels:        {
        "cluster.emil-jacero.com/name": *name | string
        ...
    }
    clusterOverrides: {
        clusterName:   *name | string
        clusterFQDN:   *"\(clusterName).\(domainSuffix)" | string
        clusterlabels: labels
    }
}
