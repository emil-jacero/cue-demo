package common

#SemVer: string & =~"^v?(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(?:-((?:0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$"

#OCIRepositoryRef: {
	digest?: string
	semver?: #SemVer
	tag?: string
}

#OCISource: {
	url:      string & =~"^oci://.*$"
	ref?: null | #OCIRepositoryRef
	user:     *"" | string
	password: *"" | string
}

#Config: {
	name:       string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	namespace:  string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	labels?:    {string: string}
	src:        #OCISource
}
