package helm

import (
	corev1 "k8s.io/api/core/v1"
	fluxsrcv1beta2 "github.com/fluxcd/source-controller/api/v1beta2"
	// fluxsrcv1 "github.com/fluxcd/source-controller/api/v1"
)

#HelmSecretName: "\(#HelmConfig.name)-helm"

#HelmRepository: fluxsrcv1beta2.#HelmRepository & {
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

// #OCISecretName: "\(#HelmConfig.name)-oci-helm"

// #OCIRepository: fluxsrcv1beta2.#OCIRepository & {
// 	_spec:      #HelmConfig
// 	metadata: {
// 		name:        _spec.name
// 		namespace:   _spec.namespace
// 		labels:      _spec.labels
// 		annotations: _spec.annotations
// 	}
// 	spec: {
// 		interval: "\(_spec.interval)m"
// 		url:      _spec.repository.url
// 		if _spec.repository.password != "" {
// 			secretRef: name: #OCISecretName
// 		}
// 		timeout: "5m"
// 	}
// }

// #OCISecret: corev1.#Secret & {
// 	_spec:      #HelmConfig
// 	apiVersion: "v1"
// 	kind:       "Secret"
// 	metadata: {
// 		name:        #OCISecretName
// 		namespace:   _spec.namespace
// 		labels:      _spec.labels
// 		annotations: _spec.annotations
// 	}
// 	stringData: {
// 		user:     _spec.repository.user
// 		password: _spec.repository.password
// 	}
// }
