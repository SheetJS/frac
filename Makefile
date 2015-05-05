LIB=frac
REQS=
ADDONS=
AUXTARGETS=

ULIB=$(shell echo $(LIB) | tr a-z A-Z)
DEPS=$(LIB).md
TARGET=$(LIB).js

.PHONY: all
all: $(TARGET) $(AUXTARGETS)

$(TARGET) $(AUXTARGETS): %.js : %.flow.js
	node -e 'process.stdout.write(require("fs").readFileSync("$<","utf8").replace(/^\s*\/\*:[^*]*\*\/\s*(\n)?/gm,"").replace(/\/\*:[^*]*\*\//gm,""))' > $@

$(LIB).flow.js: $(DEPS)
	voc $^

.PHONY: clean
clean:
	rm -f $(TARGET)


.PHONY: test mocha
test mocha: test.js
	mocha -R spec -t 20000

.PHONY: lint
lint: $(TARGET) $(AUXTARGETS)
	jshint --show-non-errors $(TARGET) $(AUXTARGETS)
	jshint --show-non-errors package.json
	jscs $(TARGET) $(AUXTARGETS)

.PHONY: flow
flow: lint
	flow check --all --show-all-errors

.PHONY: cov cov-spin
cov: misc/coverage.html
cov-spin:
	make cov & bash misc/spin.sh $$!

misc/coverage.html: $(TARGET) test.js
	mocha --require blanket -R html-cov -t 20000 > $@

.PHONY: coveralls coveralls-spin
coveralls:
	mocha --require blanket --reporter mocha-lcov-reporter -t 20000 | ./node_modules/coveralls/bin/coveralls.js

coveralls-spin:
	make coveralls & bash misc/spin.sh $$!

.PHONY: dist
dist: dist-deps $(TARGET)
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
pylint: frac.py $(wildcard test_*.py)
	pep8 $^

.PHONY: pypi
pypi: frac.py
	python setup.py sdist upload

.PHONY: pytest pypytest
pytest: pylint
	py.test -v --durations=5

pypytest: pylint
	pypy $$(which py.test) -v --durations=5
