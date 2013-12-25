# frac

Rational approximation to a floating point number with bounded denominator.

Uses the Mediant Method <https://en.wikipedia.org/wiki/Mediant_(mathematics)>

This module also provides an implementation of the continued fraction method as
described by Aberth in "A method for exact computation with rational numbers", 
which appears to be used by spreadsheet programs for displaying fractions

## JS Installation and Usage

In node:

    $ npm install frac

In the browser:

    <script src="frac.js"></script>

The exported `frac` function takes three arguments:

 - `x` the number we wish to approximate
 - `D` the maximum denominator
 - `mixed` if true, return a mixed fraction (default); if false, improper

The return value is an array of the form `[quot, num, den]` where `quot==0`
for improper fractions.

For example:

```
> // var frac = require('frac'); // uncomment this line if in node
> frac(Math.PI,100) // [ 0, 22, 7 ]
> frac(Math.PI,100,true) // [ 3, 1, 7 ]
```

`frac.cont` implements the Aberth algorithm (input and output specifications
match the original `frac` function)
