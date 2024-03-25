module: "github.com/emil-jacero/cue-demo/example1@v0"
language: {
	version: "v0.8.0"
}
deps: {
	"github.com/emil-jacero/cue-demo/apps/alertmanager@v0": {
		v: "v0.0.1"
	}
	"github.com/emil-jacero/cue-demo/apps/grafanaoperator@v0": {
		v: "v0.0.1"
	}
	"github.com/emil-jacero/cue-demo/apps/podinfo@v0": {
		v: "v0.2.2"
	}
	"github.com/emil-jacero/cue-demo/apps/prometheus@v0": {
		v: "v0.0.1"
	}
	"github.com/emil-jacero/cue-demo/modules/cluster@v0": {
		v: "v0.6.0"
	}
	"github.com/emil-jacero/cue-demo/modules/fluxcd@v0": {
		v: "v0.1.5"
	}
	"github.com/fluxcd@v1": {
		v:       "v1.0.0"
		default: true
	}
	"k8s.io@v1": {
		v:       "v1.0.0"
		default: true
	}
}
