package clusters

import (
	kubernetes "k8s.io/apimachinery/pkg/runtime"
)

#MyCluster: #MyClusterConfig & {
	name:          *"cluster01" | string
    role:          *"prod" | "stage" | "dev"
    domainSuffix:  *"example.com" | string
    labels:        {
        "cluster.example2/name": name
        "cluster.example2/role": role
    }
    clusterOverrides: {
        clusterName:   *name | string
        clusterFQDN:   *"\(name).\(role).\(domainSuffix)" | string
    }
    apps: {...}
    bundles: {...}

	resources: [ID=_]:     kubernetes.#Object
    let _labels = labels

    for k, v in apps {
        for rk, rv in v.resources {
            resources: "\(k)-\(rk)": rv
            resources: "\(k)-\(rk)": metadata: labels: _labels
        }
    }
    for k, v in bundles {
        for rk, rv in v.resources {
            resources: "\(k)-\(rk)": rv
            resources: "\(k)-\(rk)": metadata: labels: _labels
        }
    }
}
