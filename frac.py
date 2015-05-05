# frac.py (C) 2015 SheetJS -- http://sheetjs.com
# vim: set fileencoding=utf-8 :
"""
Rational approximations to numbers

This module can generate fraction representations using:
- Mediant method (akin to fractions.Fraction#limit_denominator)
- Aberth method (as used by spreadsheet software)

All functions take 3 arguments:

- x: the number to be approximated
- D: the max denominator
- mixed: if True, generate a mixed representation

The return value is a list of 3 elements: [quotient, numerator, denominator]
"""


def med(x, D, mixed=False):
    """Generate fraction representation using Mediant method"""
    n1, d1 = int(x), 1
    n2, d2 = n1+1, 1
    m = 0.
    if x != n1:
        while d1 <= D and d2 <= D:
            m = float(n1 + n2) / (d1 + d2)
            if x == m:
                if d1 + d2 <= D:
                    n1, d1 = n1 + n2, d1 + d2
                    d2 = D + 1
                elif d1 > d2:
                    d2 = D+1
                else:
                    d1 = D+1
                break
            elif x < m:
                n2, d2 = n1+n2, d1+d2
            else:
                n1, d1 = n1+n2, d1+d2
    if d1 > D:
        n1, d1 = n2, d2
    if not mixed:
        return [0, n1, d1]
    q = divmod(n1, d1)
    return [q[0], q[1], d1]


def cont(x, D, mixed=False):
    """Generate fraction representation using Aberth method"""
    B = abs(x)
    I = int
    P_2, P_1, P, Q_2, Q_1, Q = 0, 1, 0, 1, 0, 0
    while Q_1 < D:
        A = I(B)
        P = A * P_1 + P_2
        Q = A * Q_1 + Q_2
        if (B - A) < 0.0000000005:
            break
        B = 1. / (B-A)
        P_2, P_1 = P_1, P
        Q_2, Q_1 = Q_1, Q
    if Q > D:
        if Q_1 <= D:
            P, Q = P_1, Q_1
        else:
            P, Q = P_2, Q_2
    sgn = -1 if x < 0 else 1
    if not mixed:
        return [0, sgn * P, Q]
    q = divmod(sgn * P, Q)
    return [q[0], q[1], Q]
