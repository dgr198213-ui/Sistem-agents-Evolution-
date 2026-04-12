.PHONY: all build test clean

all: build test

build:
	bash tools/build.sh

test:
	nim c -r tests/test_runner.nim

clean:
	rm -rf build/ nimcache/
