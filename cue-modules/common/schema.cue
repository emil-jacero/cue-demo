package common

#OCIRepositoryRef: {
	digest?: string
	semver?: #SemVerString
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
