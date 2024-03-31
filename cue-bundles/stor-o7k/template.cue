package stor_o7k

import (
	"github.com/emil-jacero/cue-demo/modules/bundle@v0"
    // Apps
	"github.com/emil-jacero/cue-demo/apps/cinder_csi@v0"
)

StorO7k: bundle.#Bundle & {
    name: "stor-o7k"
    apps: {
        "cinder-csi": cinder_csi.#CinderCsi & {
            spec: {
                chart: version: "2.29.0"
                values: {
                    secret: {
                        enabled:   true
                        hostMount: true
                        create:    true
                        filename:  "cloud.conf"
                        name:      "cinder-csi-cloud-config"
                        data: "cloud.conf": """
                            [Global]
                            auth-url=http://openstack-control-plane
                            user-id=user-id
                            password=password
                            trust-id=trust-id
                            region=RegionOne
                            ca-file=/etc/cacert/ca-bundle.crt
                            """
                    }
                    storageClass: {
                        enabled: true
                        delete: {
                            isDefault:            false
                            allowVolumeExpansion: true
                        }
                        retain: {
                            isDefault:            true
                            allowVolumeExpansion: true
                        }
                    }
                }
            }
        }
    }
}
