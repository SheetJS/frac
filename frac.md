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
            if(d1 + d2 <= D) { d1+=d2; n1+=n2; d2=D+1; }
            else if(d1 > d2) d2=D+1;
            else d1=D+1;
            break;
        }
```

Otherwise shrink the range:

```
        else if(x < m) { n2 = n1+n2; d2 = d1+d2; }
        else { n1 = n1+n2; d1 = d1+d2; }
    }
```

At this point, `d1 > D` or `d2 > D` (but not both -- keep track of how `d1` and
`d2` change).  So we merely return the desired values:

```
    if(d1 > D) { d1 = d2; n1 = n2; }
    if(!mixed) return [0, n1, d1];
    var q = Math.floor(n1/d1);
    return [q, n1 - q*d1, d1];
};
```

## Continued Fraction Method

The continued fraction technique is employed by various spreadsheet programs.  
Note that this technique is inferior to the mediant method (at least, according
to the desired goal of most accurately approximating the floating point number)

```
frac.cont = function cont(x, D, mixed) {
```

> Record the sign of x, take b0=|x|, p_{-2}=0, p_{-1}=1, q_{-2}=1, q_{-1}=0

Note that the variables are implicitly indexed at `k` (so `B` refers to `b_k`):

```
    var sgn = x < 0 ? -1 : 1;
    var B = x * sgn;
    var P_2 = 0, P_1 = 1, P = 0;
    var Q_2 = 1, Q_1 = 0, Q = 0;
    var A = B|0;
```

> Iterate

> ... for k = 0,1,...,K, where K is the first instance of k where 
> either q_{k+1} > Q or b_{k+1} is undefined (b_k = a_k).

```
    while(Q_1 < D) {
```

> a_k = [b_k], i.e., the greatest integer <= b_k

```
        A = B|0;
```

> p_k = a_k p_{k-1} + p_{k-2}
> q_k = a_k q_{k-1} + q_{k-2}

```
        P = A * P_1 + P_2;
        Q = A * Q_1 + Q_2;
```

> b_{k+1} = (b_{k} - a_{k})^{-1} 

```
        if((B - A) < 0.00000001) break;
```

At the end of each iteration, advance `k` by one step:

``` 
        B = 1 / (B - A);
        P_2 = P_1; P_1 = P;
        Q_2 = Q_1; Q_1 = Q;
    }
```

In case we end up overstepping, walk back an iteration or two: 

```
    if(Q > D) { Q = Q_1; P = P_1; }
    if(Q > D) { Q = Q_2; P = P_2; }
```

The final result is `r = (sgn x)p_k / q_k`:

```
    if(!mixed) return [0, sgn * P, Q];
    var q = Math.floor(sgn * P/Q);
    return [q, sgn*P - q*Q, Q];
};
```

Finally we put some export jazz:

```
if(typeof module !== 'undefined') module.exports = frac;
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
    "version": "0.2.0",
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


