package common

#SemVerString: string & =~"^v?(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(?:-((?:0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$"

#SemVer: {
	// Input version string in strict semver format.
	#Version!: string & =~"^\\d+\\.\\d+\\.\\d+(-[0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*)?(\\+[0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*)?$"

	// Minimum is the minimum allowed MAJOR.MINOR version.
	#Minimum: *"0.0.0" | string & =~"^\\d+\\.\\d+\\.\\d+(-[0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*)?(\\+[0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*)?$"

	let minMajor = strconv.Atoi(strings.Split(#Minimum, ".")[0])
	let minMinor = strconv.Atoi(strings.Split(#Minimum, ".")[1])

	major: int & >=minMajor
	major: strconv.Atoi(strings.Split(#Version, ".")[0])

	minor: int & >=minMinor
	minor: strconv.Atoi(strings.Split(#Version, ".")[1])
}