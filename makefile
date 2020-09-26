.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

init: ## Install package dependencies
	cp .env-example .env
	pip install --upgrade pip
	# install test project and package dependencies
	pip install -r requirements.txt
	# install package
	pip install .
	# install dev dependencies (see setup.py)
	pip install .[test,dev]
test: ## Run package tests
	python -m pytest tests
ci: ## [CI] Run package tests and lint
	make test
	make lint
lint: ## Run code linting
	python -m flake8 src/masonite/package/ --ignore=E501,F401,E128,E402,E731,F821,E712,W503
format: ## Format code with Black
	black src/masonite/package
coverage: ## Run package tests and upload coverage reports
	python -m pytest --cov-report term --cov-report xml --cov=src/masonite/package tests/
	python -m coveralls
publish: ## Publish package to pypi
	python setup.py sdist bdist_wheel
	twine upload dist/*
	rm -fr build dist .egg masonite.egg-info
pypirc: ## Copy the template .pypirc in the repo to your home directory
	cp .pypirc ~/.pypirc