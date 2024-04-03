package helm

import (
	kubernetes "k8s.io/apimachinery/pkg/runtime"
)

#OCIProviders: "aws" | "azure" | "gcp" | "generic"

#HelmConfig: {
	name:      string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	namespace: string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	targetNamespace?: string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	labels: {
		"helm.toolkit.fluxcd.io/name": *name | string,
		...
	}
	annotations: "helm.toolkit.fluxcd.io/version": *chart.version | string
	serviceAccountName?: string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	interval:            *10 | int
	repository: {
		url:      string & =~"^[http|oci]"
		provider?: string & #OCIProviders
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

	// Combine values with the configMap values file
	if spec.values != null {
		let rv = #ReleaseValues & {_spec: spec}
		resources: "\(spec.name)-values": rv
		valuesFrom: "\(rv.kind)":         rv.metadata.name
	}

	// Combine secretValues with the secret values file
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

	resources: "\(spec.name)-namespace": #Namespace & {_spec: spec}
}