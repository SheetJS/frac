LIB=frac
REQS=
ADDONS=
AUXTARGETS=
HTMLLINT=index.html

ULIB=$(shell echo $(LIB) | tr a-z A-Z)
DEPS=$(LIB).md
TARGET=$(LIB).js
FLOWTARGET=$(LIB).flow.js

## Main Targets

.PHONY: all
all: $(TARGET) $(AUXTARGETS) ## Build library and auxiliary scripts

$(TARGET) $(AUXTARGETS): %.js : %.flow.js
	node -e 'process.stdout.write(require("fs").readFileSync("$<","utf8").replace(/^[ \t]*\/\*[:#][^*]*\*\/\s*(\n)?/gm,"").replace(/\/\*[:#][^*]*\*\//gm,""))' > $@

$(FLOWTARGET): $(DEPS)
	voc $^

.PHONY: clean
clean: ## Remove targets and build artifacts
	rm -f $(TARGET) $(FLOWTARGET)

## JavaScript

.PHONY: test mocha
test mocha: test.js $(TARGET) ## Run JS test suite
	mocha -R spec -t 20000

.PHONY: lint
lint: $(TARGET) $(AUXTARGETS) ## Run jshint and jscs checks
	@jshint --show-non-errors $(TARGET) $(AUXTARGETS)
	@jshint --show-non-errors package.json
	@jshint --show-non-errors --extract=always $(HTMLLINT)
	@jscs $(TARGET) $(AUXTARGETS)

.PHONY: flow
flow: lint ## Run flow checker
	@flow check --all --show-all-errors

.PHONY: cov
cov: misc/coverage.html ## Run coverage test

misc/coverage.html: $(TARGET) test.js
	mocha --require blanket -R html-cov -t 20000 > $@

.PHONY: coveralls
coveralls: ## Coverage Test + Send to coveralls.io
	mocha --require blanket --reporter mocha-lcov-reporter -t 20000 | node ./node_modules/coveralls/bin/coveralls.js

.PHONY: dist
dist: dist-deps $(TARGET) ## Prepare JS files for distribution
	cp $(TARGET) dist/
	cp LICENSE dist/
	uglifyjs $(TARGET) -o dist/$(LIB).min.js --source-map dist/$(LIB).min.map --preamble "$$(head -n 1 frac.js)"
	misc/strip_sourcemap.sh dist/$(LIB).min.js

.PHONY: aux
aux: $(AUXTARGETS)
.PHONY: dist-deps
dist-deps:

## Python

.PHONY: pylint
pylint: frac.py $(wildcard test_*.py) ## Run pep8 check
	pep8 $^

.PHONY: pypi
pydist: frac.py ## Upload Python module to PyPI
	python setup.py sdist upload

.PHONY: pytest pypytest
pytest: pylint ## Run Python test suite
	py.test -v --durations=5

pypytest: pylint ## Run Python test suite in pypy
	pypy $$(which py.test) -v --durations=5

.PHONY: help
help:
	@grep -hE '(^[a-zA-Z_-][ a-zA-Z_-]*:.*?|^#[#*])' $(MAKEFILE_LIST) | bash misc/help.sh

#* To show a spinner, append "-spin" to any target e.g. cov-spin
%-spin:
	@make $* & bash misc/spin.sh $$!
