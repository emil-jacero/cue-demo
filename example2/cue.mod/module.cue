module: "github.com/emil-jacero/cue-demo/example1@v0"
language: {
	version: "v0.8.0"
}
deps: {
	"github.com/fluxcd@v1": {
		v:       "v1.0.0"
		default: true
	}
	"k8s.io@v1": {
		v:       "v1.0.0"
		default: true
	}
}
