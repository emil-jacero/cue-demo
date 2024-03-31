package clusters

// #Cluster: #ClusterConfig & {
// 	name:          *"cluster01" | string
//     domainSuffix:  *"example.com" | string
//     labels:        {
//         "cluster.emil-jacero.com/name": *name | string
//         ...
//     }
//     clusterOverrides: {
//         clusterName:   *name | string
//         clusterFQDN:   *"\(clusterName).\(domainSuffix)" | string
//         clusterlabels: labels
//     }
// }

#MyCluster: #MyClusterConfig & {
	name:          *"cluster01" | string
    role:          *"prod" | "stage" | "dev"
    domainSuffix:  *"example.com" | string
    labels:        {
        "cluster.emil-jacero.com/name": *name | string
        ...
    }
    clusterOverrides: {
        clusterName:   *name | string
        clusterFQDN:   *"\(name).\(role).\(domainSuffix)" | string
        clusterlabels: labels
    }
}
