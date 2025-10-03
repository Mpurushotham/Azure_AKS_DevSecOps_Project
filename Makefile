.PHONY: help install dev build test clean

help:
	@echo "Available commands:"
	@echo "  make install    - Install dependencies"
	@echo "  make dev        - Start development environment"
	@echo "  make build      - Build containers"
	@echo "  make test       - Run tests"
	@echo "  make clean      - Clean build artifacts"

install:
	cd src/frontend && npm install
	cd src/backend && npm install

dev:
	bash scripts/local-dev/start-dev.sh

build:
	docker-compose -f docker-compose.dev.yml build

test:
	cd src/frontend && npm test
	cd src/backend && npm test

clean:
	docker-compose -f docker-compose.dev.yml down -v
	rm -rf src/frontend/node_modules
	rm -rf src/backend/node_modules
