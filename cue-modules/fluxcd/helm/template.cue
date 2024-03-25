package helm

import (
	"strings"
	"uuid"
	"encoding/yaml"

	corev1 "k8s.io/api/core/v1"
	fluxsrcv1beta2 "github.com/fluxcd/source-controller/api/v1beta2"
	fluxhrv2beta2 "github.com/fluxcd/helm-controller/api/v2beta2"
)

#HelmRepository: fluxsrcv1beta2.#HelmRepository & {
	_spec:      #HelmConfig
	apiVersion: "source.toolkit.fluxcd.io/v1beta2"
	kind:       "HelmRepository"
	metadata: {
		name:        _spec.name
		namespace:   _spec.namespace
		labels:      _spec.labels
		annotations: _spec.annotations
	}
	spec: {
		interval: "\(_spec.interval)m"
		timeout: "2m"
		if _spec.repository.url =~ "^http.*" {
			type: "default"
			url:  _spec.repository.url
			if _spec.repository.password != "" {
				secretRef: name: #HelmSecretName
			}
		}
		if _spec.repository.url =~ "^oci.*"  {
			type: "oci"
			url:  _spec.repository.url
		}
	}
}

#HelmSecretName: "\(#HelmConfig.name)-helm"
#HelmSecret: corev1.#Secret & {
	_spec:      #HelmConfig
	apiVersion: "v1"
	kind:       "Secret"
	metadata: {
		name:        #HelmSecretName
		namespace:   _spec.namespace
		labels:      _spec.labels
		annotations: _spec.annotations
	}
	stringData: {
		user:     _spec.repository.user
		password: _spec.repository.password
	}
}

#HelmRelease: fluxhrv2beta2.#HelmRelease & {
	_spec: #HelmConfig
	_valuesFrom: [ string]: string
	apiVersion: "helm.toolkit.fluxcd.io/v2beta2"
	kind:       "HelmRelease"
	metadata: {
		name:        _spec.name
		namespace:   _spec.namespace
		labels:      _spec.labels
		annotations: _spec.annotations
	}
	spec: {
		if _spec.serviceAccountName != _|_ {
			serviceAccountName: _spec.serviceAccountName
		}
		if _spec.targetNamespace != _|_ {
			install: createNamespace: true
			targetNamespace:  _spec.targetNamespace
			storageNamespace: _spec.targetNamespace
		}
		interval: "\(2*_spec.interval)m"
		chart: {
			spec: {
				chart:   _spec.chart.name
				version: _spec.chart.version
				sourceRef: {
					kind: "HelmRepository"
					name: _spec.name
				}
				interval: "\(_spec.interval)m"
			}
		}
		install: crds: "Create"
		upgrade: crds: "CreateReplace"
		valuesFrom: [
			for k, n in _valuesFrom {
				kind: k
				name: n
			},
		]
	}
}

#ReleaseValues: corev1.#ConfigMap & {
	_spec: #HelmConfig
	let _values_yaml = yaml.Marshal(_spec.values)
	let _values_sha = strings.Split(uuid.SHA1(uuid.ns.DNS, _values_yaml), "-")[0]
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:        "\(_spec.name)-\(_values_sha)"
		namespace:   _spec.namespace
		labels:      _spec.labels
		annotations: _spec.annotations
	}
	immutable: true
	data: {
		"values.yaml": _values_yaml
	}
}

#ReleaseSecretValues: corev1.#Secret & {
	_spec: #HelmConfig
	let _values_yaml = yaml.Marshal(_spec.secretValues)
	let _values_sha = strings.Split(uuid.SHA1(uuid.ns.DNS, _values_yaml), "-")[0]
	apiVersion: "v1"
	kind:       "Secret"
	metadata: {
		name:        "\(_spec.name)-\(_values_sha)"
		namespace:   _spec.namespace
		labels:      _spec.labels
		annotations: _spec.annotations
	}
	immutable: true
	stringData: {
		"values.yaml": _values_yaml
	}
}
