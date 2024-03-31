package clusters

import (
	// "strings"
	"text/tabwriter"
	"tool/cli"
	// "tool/exec"
	// "tool/file"
	// "path"
	"encoding/yaml"
)

#Clusters: [...]

command: build: {
	outDir: ".output"
	for cl in #Clusters {
		for k, v in cl.bundles {
			for rk, rv in v.resources {
				"\(cl.name)-\(cl.role)-\(k)-\(rk)": {
					printRes: cli.Print & {
						text: yaml.MarshalStream({rk, rv})
					}
				}
			}
		}
	}
}


command: lsapps: {
    task: {
        gather: {
            items: [for cl in #Clusters for k, v in cl.apps {
				_cl_name: "\(cl.name)-\(cl.role)"
				_app_name: "\(v.spec.name)"
				_app_chart_version: "\(v.spec.chart.version)"
				_app_namespace: "\(v.spec.namespace)"
				_app_repository: "\(v.spec.repository.url)"
				"\(_cl_name) \t\(_app_name) \t\(_app_namespace) \t\(_app_chart_version) \t\(_app_repository)"
            }]
        }
        print: cli.Print & {
            $dep: gather
            text: tabwriter.Write([
                "CLUSTER \tAPP \tNAMESPACE \tVERSION \tURL",
                for a in gather.items {
                    "\(a)"
                }
            ])
        }
    }
}

command: lsresources: {
    task: {
        gather: {
            items: [for cl in #Clusters for k, v in cl.apps for rs_k, rs_v in v.resources {
				_cl_name: "\(cl.name)-\(cl.role)"
				_rs_name: "\(rs_k)"
				"\(_cl_name) \t\(_rs_name)"
            }]
        }
        print: cli.Print & {
            $dep: gather
            text: tabwriter.Write([
                "CLUSTER \tRESOURCE",
                for a in gather.items {
                    "\(a)"
                }
            ])
        }
    }
}
