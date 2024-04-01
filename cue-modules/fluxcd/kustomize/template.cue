package kustomize

import (
	"strings"
	"uuid"
	"encoding/yaml"

	corev1 "k8s.io/api/core/v1"
	fluxsrcv1beta2 "github.com/fluxcd/source-controller/api/v1beta2"
	fluxksv1 "github.com/fluxcd/kustomize-controller/api/v1"
)

#OCIRepository: fluxsrcv1beta2.#OCIRepository & {
	_spec:      #KustomizeConfig
	apiVersion: "source.toolkit.fluxcd.io/v1beta2"
	kind:       "OCIRepository"
	metadata: {
		name:        _spec.name
		namespace:   _spec.namespace
		labels:      _spec.labels
		annotations: _spec.annotations
	}
	spec: {
		interval: "\(_spec.interval)m"
		timeout: "2m"
	}
}

#GitRepository: fluxsrcv1beta2.#GitRepository & {
	_spec:      #KustomizeConfig
	apiVersion: "source.toolkit.fluxcd.io/v1beta2"
	kind:       "GitRepository"
	metadata: {
		name:        _spec.name
		namespace:   _spec.namespace
		labels:      _spec.labels
		annotations: _spec.annotations
	}
	spec: {
		interval: "\(_spec.interval)m"
		timeout: "2m"
	}
}

#Kustomization: fluxksv1.#Kustomization & {
	_spec:      #KustomizeConfig
}
