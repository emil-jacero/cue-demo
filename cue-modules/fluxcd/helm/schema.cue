package helm

import (
	kubernetes "k8s.io/apimachinery/pkg/runtime"
)

#HelmConfig: {
	name:      string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	namespace: string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	targetNamespace?: string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	labels: {
		"helmrelease.toolkit.fluxcd.io/name": *name | string,
		...
	}
	annotations: "helmrelease.toolkit.fluxcd.io/version": *chart.version | string
	serviceAccountName?: string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	interval:            *10 | int
	repository: {
		url:      string & =~"^[http|oci]"
		user:     *"" | string
		password: *"" | string
	}
	chart: {
		name:    string
		version: string
	}
	values:       *null | {...}
	secretValues: *null | {...}
}

#Helm: {
	spec: #HelmConfig
	resources: [ID=_]:     kubernetes.#Object
	valuesFrom: [ string]: string

	// Define values configMap
	if spec.values != null {
		let rv = #ReleaseValues & {_spec: spec}
		resources: "\(spec.name)-values": rv
		valuesFrom: "\(rv.kind)":         rv.metadata.name
	}

	// Define secret values secret
	if spec.secretValues != null {
		let rs = #ReleaseSecretValues & {_spec: spec}
		resources: "\(spec.name)-secrets": rs
		valuesFrom: "\(rs.kind)":          rs.metadata.name
	}

	resources: "\(spec.name)-repository": #HelmRepository & {_spec: spec}
	resources: "\(spec.name)-release":    #HelmRelease & {_spec:    spec, _valuesFrom: valuesFrom}

	if spec.repository.password != "" {
		resources: "\(spec.name)-reposecret": #HelmSecret & {_spec: spec}
	}
}