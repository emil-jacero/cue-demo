package clusters

import (
	"strings"
	"text/tabwriter"
	"tool/cli"
	"tool/exec"
	"tool/file"
	"path"
	// "encoding/yaml"
)

#Clusters: [...]

command: build: {
	outDir: ".output"
	for cl in #Clusters {
		for k,v in cl.instances {
			"\(cl.name)-\(cl.group)-\(k)": { // This is done to make it unique :)
				clInstDir: path.Join([outDir, "\(cl.name)-\(cl.group)", "bundles"])
				#splitS: strings.Split(url, "/")
				name: #splitS[len(#splitS) - 1]
				url: "\(v.source.url)"
				tag: "\(v.source.tag)"
				yamlFile: path.Join([clInstDir, "\(name).resources.yaml"])
				bundleFile: path.Join([clInstDir, "\(name).bundle.cue"])

				print: cli.Print & {
					text: "Building bundle \(name) with version \(tag) to path (\(bundleFile))"
				}
				publishBundle: {
					get: exec.Run & {
						cmd: [ "timoni", "artifact", "pull", "\(url):\(tag)", "-o", "\(clInstDir)/"]
					}
					build: exec.Run & {
						$dep: get.$done
						cmd: [ "timoni", "bundle", "build", "-f", bundleFile, "-f", "config.cue"]
						stdout: string
						Out:    stdout
					}
					write: file.Create & {
						$dep: build
						filename: yamlFile
						contents: build.Out
					}
					// publishArtifact exec.Run & {
					// 	$dep: build
					// 	cmd: [ "flux", "push", "artifact", "oci://localhost:5000/flux/:", "", "", "", "", "", ""]
					// 	stdout: string
					// 	Out:    stdout
					// }
				}
			}
		}
	}
}

command: ls: {
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
