package bundle

#BundleConfig: {
	name:      string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	namespace: string & =~"^[a-z0-9]([a-z0-9\\-]){0,61}[a-z0-9]$"
	labels: {[string]: string}
	apps: {...}
    ...
}