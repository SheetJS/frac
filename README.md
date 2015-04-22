# frac

Rational approximation to a floating point number with bounded denominator.

Uses the [Mediant Method](https://en.wikipedia.org/wiki/Mediant_method).

This module also provides an implementation of the continued fraction method as
described by Aberth in "A method for exact computation with rational numbers".

## Installation

With [npm](https://www.npmjs.org/package/frac):

    $ npm install frac

In the browser:

    <script src="frac.js"></script>

The script will manipulate `module.exports` if available (e.g. in a CommonJS
`require` context).  This is not always desirable.  To prevent the behavior,
define `DO_NOT_EXPORT_FRAC`

## Usage

The exported `frac` function takes three arguments:

 - `x` the number we wish to approximate
 - `D` the maximum denominator
 - `mixed` if true, return a mixed fraction; if false, improper

The return value is an array of the form `[quot, num, den]` where `quot==0`
for improper fractions.  `quot <= x` for mixed fractions, which may lead to some
unexpected results when rendering negative numbers.

For example:

```
> // var frac = require('frac'); // uncomment this line if in node
> frac(Math.PI,100); // [ 0, 22, 7 ]
> frac(Math.PI,100,true); // [ 3, 1, 7 ]
> frac(-Math.PI,100); // [ 0, -22, 7 ]
> frac(-Math.PI,100,true); // [ -4, 6, 7 ] // the approximation is (-4) + (6/7)
```

`frac.cont` implements the Aberth algorithm (input and output specifications
match the original `frac` function)

## Testing

`make test` will run the node-based tests.

Tests generated from Excel have 4 columns.  To produce a similar test:

- Column A contains the raw values
- Column B format "Up to one digit (1/4)"
- Column C format "Up to two digits (21/25)"
- Column D format "Up to three digits (312/943)"

## License

Please consult the attached LICENSE file for details.  All rights not explicitly
granted by the Apache 2.0 license are reserved by the Original Author.

## Badges

[![Build Status](https://travis-ci.org/SheetJS/frac.svg?branch=master)](https://travis-ci.org/SheetJS/frac)

[![Coverage Status](http://img.shields.io/coveralls/SheetJS/frac/master.svg)](https://coveralls.io/r/SheetJS/frac?branch=master)

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/731e31b3a26382ccd5d213b9e74ea552 "githalytics.com")](http://githalytics.com/SheetJS/frac)
