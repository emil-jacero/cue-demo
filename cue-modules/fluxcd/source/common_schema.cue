package source

import (
    metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

#SourceSpec: {
	apiVersion: metav1.#TypeMeta.apiVersion & "source.toolkit.fluxcd.io/v1beta2"
}

#Artifact: {
	// Path is the relative file path of the Artifact. It can be used to locate
	// the file in the root of the Artifact storage on the local file system of
	// the controller managing the Source.
	// +required
	path: string

	// URL is the HTTP address of the Artifact as exposed by the controller
	// managing the Source. It can be used to retrieve the Artifact for
	// consumption, e.g. by another controller applying the Artifact contents.
	// +required
	url: string

	// Revision is a human-readable identifier traceable in the origin source
	// system. It can be a Git commit SHA, Git tag, a Helm chart version, etc.
	// +optional
	revision?: string

	// Checksum is the SHA256 checksum of the Artifact file.
	// Deprecated: use Artifact.Digest instead.
	// +optional
	checksum?: string

	// Digest is the digest of the file in the form of '<algorithm>:<checksum>'.
	// +optional
	// +kubebuilder:validation:Pattern="^[a-z0-9]+(?:[.+_-][a-z0-9]+)*:[a-zA-Z0-9=_-]+$"
	digest?: string

	// LastUpdateTime is the timestamp corresponding to the last update of the
	// Artifact.
	// +required
	lastUpdateTime?: metav1.#Time

	// Size is the number of bytes in the file.
	// +optional
	size?: null | int64

	// Metadata holds upstream information such as OCI annotations.
	// +optional
	metadata?: {[string]: string}
}

#Duration: "^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"

#SemVer: "^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$"

#SourceFinalizer: "finalizers.fluxcd.io"

// ArtifactInStorageCondition indicates the availability of the Artifact in
// the storage.
// If True, the Artifact is stored successfully.
// This Condition is only present on the resource if the Artifact is
// successfully stored.
#ArtifactInStorageCondition: "ArtifactInStorage"

// ArtifactOutdatedCondition indicates the current Artifact of the Source
// is outdated.
// This is a "negative polarity" or "abnormal-true" type, and is only
// present on the resource if it is True.
#ArtifactOutdatedCondition: "ArtifactOutdated"

// SourceVerifiedCondition indicates the integrity verification of the
// Source.
// If True, the integrity check succeeded. If False, it failed.
// This Condition is only present on the resource if the integrity check
// is enabled.
#SourceVerifiedCondition: "SourceVerified"

// FetchFailedCondition indicates a transient or persistent fetch failure
// of an upstream Source.
// If True, observations on the upstream Source revision may be impossible,
// and the Artifact available for the Source may be outdated.
// This is a "negative polarity" or "abnormal-true" type, and is only
// present on the resource if it is True.
#FetchFailedCondition: "FetchFailed"

// BuildFailedCondition indicates a transient or persistent build failure
// of a Source's Artifact.
// If True, the Source can be in an ArtifactOutdatedCondition.
// This is a "negative polarity" or "abnormal-true" type, and is only
// present on the resource if it is True.
#BuildFailedCondition: "BuildFailed"

// StorageOperationFailedCondition indicates a transient or persistent
// failure related to storage. If True, the reconciliation failed while
// performing some filesystem operation.
// This is a "negative polarity" or "abnormal-true" type, and is only
// present on the resource if it is True.
#StorageOperationFailedCondition: "StorageOperationFailed"

// URLInvalidReason signals that a given Source has an invalid URL.
#URLInvalidReason: "URLInvalid"

// AuthenticationFailedReason signals that a Secret does not have the
// required fields, or the provided credentials do not match.
#AuthenticationFailedReason: "AuthenticationFailed"

// VerificationError signals that the Source's verification
// check failed.
#VerificationError: "VerificationError"

// DirCreationFailedReason signals a failure caused by a directory creation
// operation.
#DirCreationFailedReason: "DirectoryCreationFailed"

// StatOperationFailedReason signals a failure caused by a stat operation on
// a path.
#StatOperationFailedReason: "StatOperationFailed"

// ReadOperationFailedReason signals a failure caused by a read operation.
#ReadOperationFailedReason: "ReadOperationFailed"

// AcquireLockFailedReason signals a failure in acquiring lock.
#AcquireLockFailedReason: "AcquireLockFailed"

// InvalidPathReason signals a failure caused by an invalid path.
#InvalidPathReason: "InvalidPath"

// ArchiveOperationFailedReason signals a failure in archive operation.
#ArchiveOperationFailedReason: "ArchiveOperationFailed"

// SymlinkUpdateFailedReason signals a failure in updating a symlink.
#SymlinkUpdateFailedReason: "SymlinkUpdateFailed"

// ArtifactUpToDateReason signals that an existing Artifact is up-to-date
// with the Source.
#ArtifactUpToDateReason: "ArtifactUpToDate"

// CacheOperationFailedReason signals a failure in cache operation.
#CacheOperationFailedReason: "CacheOperationFailed"