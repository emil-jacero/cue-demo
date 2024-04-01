package clusters

import (
	// "strings"
	"text/tabwriter"
	"tool/cli"
	// "tool/exec"
	"tool/file"
	"path"
	"encoding/yaml"
	"encoding/json"
	// kubernetes "k8s.io/apimachinery/pkg/runtime"
)

#Clusters: [...]

command: view: {
	outDir: ".output"
	for cl in #Clusters {
		_list: [for k, v in cl.resources {v}]
		clusterDir: path.Join([outDir, "\(cl.name)-\(cl.role)"])
		print: cli.Print & {
			$after: _list
			text:  yaml.MarshalStream(_list)
		}
	}
}
command: build: {
	outDir: ".output"
	for cl in #Clusters {
		_list: [for k, v in cl.resources {v}]
		clusterDir: path.Join([outDir, "\(cl.name)-\(cl.role)"])
		print: cli.Print & {
			$after: _list
			text: "Exporting resources to \(clusterDir)/"
		}
		mkdir: file.MkdirAll & {
			$after: print
			path:   "\(clusterDir)"
		}
		write: file.Create & {
			$after:   mkdir
			filename: "\(clusterDir)/resources.yaml"
			contents: yaml.MarshalStream(_list)
		}
	}
}

command: ls_apps: {
    task: {
		gatherApps: {
			items: [for cl in #Clusters for ak, av in cl.apps {
				_clName: "\(cl.name)-\(cl.role)"
				_appName: "\(av.spec.name)"
				_appNamespace: "\(av.spec.namespace)"
				_appChartVersion: "\(av.spec.chart.version)"
				_appRepository: "\(av.spec.repository.url)"
				"\(_clName) \t \t\(_appName) \t\(_appNamespace) \t\(_appChartVersion) \t\(_appRepository)"
			}]
		}
        print: cli.Print & {
            $dep1: gatherApps
			items: gatherApps.items
            text: tabwriter.Write([
                "CLUSTER \tBUNDLE \tAPP \tNAMESPACE \tVERSION \tREPOSITORY",
                for a in items {
                    "\(a)"
                }
            ])
        }
    }
}

command: ls_resources: {
    task: {
        gather: {
			items: [for cl in #Clusters for rk, rv in cl.resources {
				_clName: "\(cl.name)-\(cl.role)"
				_resName: rv.metadata.name
				_resNamespace: rv.metadata.namespace
				_resKind: rv.kind
				_resLabels: json.Marshal(rv.metadata.labels)

				if rv.spec.targetNamespace == _|_ {
					"\(_clName) \t\(_resName) \t\(_resNamespace) \t\(_resNamespace) \t\(_resKind) \t\(_resLabels)"
				}
				if rv.spec.targetNamespace != _|_ {
					_resTargetNamespace: rv.spec.targetNamespace
					"\(_clName) \t\(_resName) \t\(_resNamespace) \t\(_resTargetNamespace) \t\(_resKind) \t\(_resLabels)"
				}
			}]
        }
        print: cli.Print & {
            $dep: gather
            text: tabwriter.Write([
                "CLUSTER \tRESOURCE \tNAMESPACE \tTARGETNAMESPACE \tKIND \tLABELS",
                for a in gather.items {
                    "\(a)"
                }
            ])
        }
    }
}
