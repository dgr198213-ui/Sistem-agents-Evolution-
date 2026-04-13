.PHONY: all build test clean run-router

all: build test

build:
	bash tools/build.sh

test:
	nim c -r tests/test_runner.nim

clean:
	rm -rf build/ nimcache/

run-router:
	python3 -m src.router.api_service
