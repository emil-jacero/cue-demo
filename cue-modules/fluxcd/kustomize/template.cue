package kustomize

import (
	"strings"
	"uuid"
	"encoding/yaml"

	corev1 "k8s.io/api/core/v1"
	fluxksv1 "github.com/fluxcd/kustomize-controller/api/v1"
)

#HelmRelease: fluxksv1.#Kustomization & {}