package kustomize

import (
	kubernetes "k8s.io/apimachinery/pkg/runtime"
)

#KustomizeConfig: {
	name:      string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	namespace: string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	targetNamespace?: string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	labels: {[string]: string} & {
		"kustomize.toolkit.fluxcd.io/name": *name | string,
		...
	}
	annotations: {[string]: string}
	serviceAccountName?: string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	interval:            *10 | int
	repository: {
		url:      string & =~"^[git|oci]"
	}
	resources: [string]
}

#Kustomize: {
	spec:              #KustomizeConfig
	resources: [ID=_]: kubernetes.#Object

	if spec.repository.url =~ "^git.*"  {
		resources: "\(spec.name)-repository": #GitRepository & {_spec: spec}
	}
	if spec.repository.url =~ "^oci.*"  {
		resources: "\(spec.name)-repository": #OCIRepository & {_spec: spec}
	}
}
