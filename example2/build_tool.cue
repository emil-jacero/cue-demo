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

command: xbuild: {
	outDir: ".output"
	for cl in #Clusters {
		for k,v in cl.apps {
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

command: build: {
	outDir: ".output"
	for cl in #Clusters {
		for k, v in cl.bundles {
			for rk, rv in v.resources {
				"\(cl.name)-\(cl.role)-\(k)-\(rk)": {
					printRes: cli.Print & {
						text: "\(rk) \t\(rv.metadata.namespace)"
					}
				}
			}
		}
	}
}

// command: lsapps: {
//     task: {
//         gather: {
// 			items: [
// 				for cl in #Clusters {
// 					_cl_name: "\(cl.name)-\(cl.role)"
// 					for k, v in cl.bundles {
// 						for ak, av in v.apps {
// 							_app_name: "\(v.spec.name)"
// 							_app_namespace: "\(v.spec.namespace)"
// 							_app_chart_version: "\(v.spec.chart.version)"
// 							_app_repository: "\(v.spec.repository.url)"
// 						}
// 						for rk, rv in v.resources {
// 							"\(cl.name)-\(cl.role)-\(k)-\(rk)": {
// 								printRes: tabwriter.Write([
// 									"CLUSTER \tAPP \tNAMESPACE \tVERSION \tURL",
// 									for a in gather.items {
// 										"\(a)"
// 									}
// 								])
// 								printRes: cli.Print & {
// 									text: "\(rk) \t\(rv.metadata.namespace)"
// 								}
// 							}
// 						}
// 					}
// 				}
// 			]
//         }
//         print: cli.Print & {
//             $dep: gather
//             text: tabwriter.Write([
//                 "CLUSTER \tAPP \tNAMESPACE \tVERSION \tURL",
//                 for a in gather.items {
//                     "\(a)"
//                 }
//             ])
//         }
//     }
// }

command: lsresources: {
    task: {
        gather: {
			items: [for cl in #Clusters for bk, bv in cl.bundles for rk, rv in bv.resources {
				_clName: "\(cl.name)-\(cl.role)"
				_bundleName: "\(bv.name)"
				_resName: rv.metadata.name
				_resNamespace: rv.metadata.namespace
				_resKind: rv.kind

				if rv.targetNamespace == _|_ {
					"\(_clName) \t\(_bundleName) \t\(_resName) \t\(_resNamespace) \t\(_resNamespace) \t\(_resKind)"
				}
				if rv.targetNamespace != _|_ {
					_resTargetNamespace: rv.targetNamespace
					"\(_clName) \t\(_bundleName) \t\(_resName) \t\(_resNamespace) \t\(_resTargetNamespace) \t\(_resKind)"
				}
				// "\(_clName) \t\(_bundleName) \t\(_resName) \t\(_resNamespace) \t\(_resNamespace) \t\(_resKind)"
			}]
        }
        print: cli.Print & {
            $dep: gather
            text: tabwriter.Write([
                "CLUSTER \tBUNDLE \tRESOURCE \tNAMESPACE \tTARGETNAMESPACE \tKIND",
                for a in gather.items {
                    "\(a)"
                }
            ])
        }
    }
}
