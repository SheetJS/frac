# Target

In all languages, the target is a function that takes 3 parameters:

 - `x` the number we wish to approximate
 - `D` the maximum denominator
 - `mixed` if true, return a mixed fraction (default); if false, improper

The JS implementation walks through the algorithm.

# JS Implementation

In this version, the return value is `[quotient, numerator, denominator]`, 
where `quotient == 0` for improper fractions. The interpretation is 
`x ~ quotient + numerator / denominator` where `0 <= numerator < denominator`
and `quotient <= x` for negative `x`.

```js>frac.js
var frac = function(x, D, mixed) {
```

The goal is to maintain a feasible fraction (with bounded denominator) below
the target and another fraction above the target.  The lower bound is 
`floor(x) / 1` and the upper bound is `(floor(x) + 1) / 1`.  We keep track of
the numerators and denominators separately:

```
    var n1 = Math.floor(x), d1 = 1;
    var n2 = n1+1, d2 = 1;
```

If `x` is not integral, we bisect using mediants until a denominator exceeds
our target:

```
    if(x !== n1) while(d1 <= D && d2 <= D) {    
```

The mediant is the sum of the numerators divided by the sum of demoninators:

```
        var m = (n1 + n2) / (d1 + d2);
```

If we happened to stumble upon the exact value, then we choose the closer one
(the mediant if the denominator is within bounds, or the bound with the larger
denominator) 

```
        if(x === m) {
            if(d1 + d2 <= D) d1+=d2, n1+=n2, d2=D+1;
            else if(d1 > d2) d2=D+1;
            else d1=D+1;
            break;
        }
```

Otherwise shrink the range:

```
        else if(x < m) n2 = n1+n2, d2 = d1+d2;
        else n1 = n1+n2, d1 = d1+d2;
    }
```

At this point, `d1 > D` or `d2 > D` (but not both -- keep track of how `d1` and
`d2` change).  So we merely return the desired values:

```
    if(d1 > D) d1 = d2, n1 = n2;
    if(!mixed) return [0, n1, d1];
    var q = Math.floor(n1/d1);
    return [q, n1 - q*d1, d1];
};
```

Finally we put some export jazz:

```
if(typeof module !== undefined) module.exports = frac;
```

# Tests

```js>test.js
var frac;
describe('source', function() { it('should load', function() { frac = require('./'); }); });
```

# Miscellany

```make>Makefile
frac.js: frac.md
        voc frac.md

.PHONY: test
test: 
        mocha -R spec
```

## Node Ilk

```json>package.json
{
    "name": "frac",
    "version": "0.1.0",
    "author": "SheetJS",
    "description": "Rational approximation with bounded denominator",
    "keywords": [ "math", "fraction", "rational", "approximation" ],
    "main": "./frac.js",
    "dependencies": {},
    "devDependencies": {"mocha":""},
    "repository": {
        "type":"git",
        "url": "git://github.com/SheetJS/frac.git"
    },
    "scripts": {
        "test": "make test"
    },
    "bugs": { "url": "https://github.com/SheetJS/frac/issues" },
    "engines": { "node": ">=0.8" }
}
```


