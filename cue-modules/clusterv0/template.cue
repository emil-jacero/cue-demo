package cluster

#DefaultPublicDomainSuffix: string & "example.com"

#RoleDev: "dev"
#RoleTest: "test"
#RoleQa: "qa"
#RoleStage: "stage"
#RoleProd: "prod"

#Cluster: #ClusterConfig & {
	name:          *"cluster01" | string
    role:          *#RoleProd | #RoleStage | #RoleQa | #RoleTest |  #RoleDev
    domainSuffix:  *#DefaultPublicDomainSuffix | string
    labels:        {
        "cluster.emil-jacero.com/name": *name | string,
        ...
    }
    clusterOverrides: {
        clusterName:   *name | string,
        clusterRole:   *role | string,
        clusterFQDN:   *"\(clusterName).\(clusterRole).\(domainSuffix)" | string,
        clusterlabels: labels
    }
}
