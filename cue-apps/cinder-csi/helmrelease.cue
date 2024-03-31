package cinder_csi

import (
	fluxhelm "github.com/emil-jacero/cue-demo/modules/fluxcd/helm@v0"
)

#CinderCsi: fluxhelm.#Helm & {
	spec: {
		name:      *"cinder-csi" | string
		namespace: *"cinder-csi" | string
		repository: {
			url: "https://kubernetes.github.io/cloud-provider-openstack"
		}
		chart: {
			name: "openstack-cinder-csi"
		}
	}
}
