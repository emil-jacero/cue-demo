package helm

import (
	corev1 "k8s.io/api/core/v1"
	source "github.com/emil-jacero/cue-demo/fluxcd/source"
)

#OCISecretName: "\(#HelmConfig.name)-oci-helm"

#OCIRepository: source.#OCIRepository & {
	_spec:      #HelmConfig
	metadata: {
		name:        _spec.name
		namespace:   _spec.namespace
		labels:      _spec.labels
		annotations: _spec.annotations
	}
	spec: {
		interval: "\(_spec.interval)m"
		url:      _spec.repository.url
		if _spec.repository.password != "" {
			secretRef: name: #OCISecretName
		}
		timeout: "5m"
	}
}

#OCISecret: corev1.#Secret & {
	_spec:      #HelmConfig
	apiVersion: "v1"
	kind:       "Secret"
	metadata: {
		name:        #OCISecretName
		namespace:   _spec.namespace
		labels:      _spec.labels
		annotations: _spec.annotations
	}
	stringData: {
		user:     _spec.repository.user
		password: _spec.repository.password
	}
}

#HelmSecretName: "\(#HelmConfig.name)-helm"

#HelmRepository: source.#HelmRepository & {
	_spec:      #HelmConfig
	metadata: {
		name:        _spec.name
		namespace:   _spec.namespace
		labels:      _spec.labels
		annotations: _spec.annotations
	}
	spec: {
		interval: "\(_spec.interval)m"
		url:      _spec.repository.url
		if _spec.repository.password != "" {
			secretRef: name: #HelmSecretName
		}
		timeout: "2m"
	}
}

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
