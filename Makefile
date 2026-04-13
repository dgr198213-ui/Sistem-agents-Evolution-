.PHONY: all build test clean run-router

all: build test

build:
	bash tools/build.sh

test:
	nim c -r tests/test_runner.nim

clean:
	rm -rf build/ nimcache/

setup:
	pip install -r requirements.txt
	@echo "Note: Please ensure Nim is installed on your system (https://nim-lang.org/)"

run-router:
	python3 -m src.router.api_service
