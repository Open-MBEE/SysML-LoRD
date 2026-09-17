.PHONY: all web validate test lint clean serve help

# Where make web assembles the static page.
WEB_OUT ?= build/web

STATICCHECK_VERSION := 2025.1.1

all: validate test web ## Validate the model, run the tests and build the page

web: ## Build the browser game into $(WEB_OUT): the runtime as WebAssembly, the page and the model
	@echo "Building the Legend of the Red Dragon for the browser..."
	@mkdir -p "$(WEB_OUT)"
	GOOS=js GOARCH=wasm go build -trimpath -ldflags "-s -w" -o "$(WEB_OUT)/lord.wasm" ./web
	cp "$$(go env GOROOT)/lib/wasm/wasm_exec.js" "$(WEB_OUT)/"
	cp web/index.html web/lord.css web/lord.js lord.sysml "$(WEB_OUT)/"
	@echo "✓ Built $(WEB_OUT)/; serve it with: make serve"

serve: web ## Serve the built page on http://localhost:8000/
	python3 -m http.server -d "$(WEB_OUT)" 8000

validate: ## Check the model with the sysml command of the OpenSysML release go.mod pins
	go tool sysml lord.sysml -validate

test: ## Run the game's tests
	go test ./...

lint: ## gofmt, go vet (host and wasm) and staticcheck
	@test -z "$$(gofmt -l .)" || { gofmt -l .; echo "gofmt: the files above need formatting"; exit 1; }
	go vet ./...
	GOOS=js GOARCH=wasm go vet ./web/...
	go install honnef.co/go/tools/cmd/staticcheck@$(STATICCHECK_VERSION)
	"$$(go env GOPATH)/bin/staticcheck" ./...
	GOOS=js GOARCH=wasm "$$(go env GOPATH)/bin/staticcheck" ./web/...

clean: ## Remove build artifacts
	rm -rf build

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-10s %s\n", $$1, $$2}'
