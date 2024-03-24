package cluster

#DomainValidator: string & =~"^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9](?:\\.[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9])+$"
#NameValidator: string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"

#ClusterOverrides: {
    clusterName:   string
    clusterRole:   string
    clusterFQDN:   string
    clusterlabels: {[string]: string}
    ...
}

#ClusterConfig: {
	name:         string
    role:         string
    domainSuffix: string
    labels:     {[string]: string}
    clusterOverrides: #ClusterOverrides
    apps: {...}
    bundles: {...}
    flavor: {...}
}
