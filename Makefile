.PHONY: frac
frac: frac.md
	voc frac.md

.PHONY: test
test:
	mocha -R spec

.PHONY: lint
lint:
	jshint --show-non-errors frac.js

.PHONY: cov
cov: coverage.html

coverage.html: frac
	mocha --require blanket -R html-cov > coverage.html

.PHONY: coveralls
coveralls:
	mocha --require blanket --reporter mocha-lcov-reporter | ./node_modules/coveralls/bin/coveralls.js
