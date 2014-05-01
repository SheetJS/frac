LIB=frac
TARGET=$(LIB).js
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

.PHONY: dist
dist: $(TARGET)
	cp $(TARGET) dist/
	cp LICENSE dist/
	uglifyjs $(TARGET) -o dist/$(LIB).min.js --source-map dist/$(LIB).min.map --preamble "$$(head -n 1 frac.js)"
