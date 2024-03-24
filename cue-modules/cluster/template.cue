package cluster

#DefaultPublicDomainSuffix: string & "example.com"

#RoleDev: "devel"
#RoleStage: "stage"
#RoleProd: "prod"

#Labels: {
    "cluster.emil-jacero.com/name": *name | string,
}

#Cluster: #ClusterConfig & {
	name:          *"cl1"
    role:          *#RoleProd | #RoleStage | #RoleDev
    domainSuffix:  *#DefaultPublicDomainSuffix
    metadata:      #Labels

    clusterOverrides: {
        clusterName: *name,
        clusterRole: *role,
        clusterFQDN: *"\(name).\(role).\(domainSuffix)",
    }
}
