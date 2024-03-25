package cluster

#ClusterOverrides: {
    clusterName:   string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
    clusterFQDN:   string & =~"^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9](?:\\.[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9])+$"
    clusterlabels: {[string]: string}
    ...
}

#ClusterConfig: {
	name:         string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
    domainSuffix: string & =~"^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9](?:\\.[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9])+$"
    labels:     {[string]: string}
    clusterOverrides: #ClusterOverrides
    apps: {...}
    bundles: {...}
    flavor: {...}
    ...
}
