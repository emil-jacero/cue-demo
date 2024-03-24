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

    globalValues: {
        clusterName:         string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$",
        clusterRole:         string,
        clusterPublicDomain: *"\(#name).\(#role).\(#domainSuffix)",
        ...
    }
}
