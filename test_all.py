import frac
import pytest

xltestfiles = [
    ['xl.00001.tsv', 10000],
    ['xl.0001.tsv',  10000],
    ['xl.001.tsv',   10000],
    ['xl.01.tsv',    10000],
    ['oddities.tsv', 25]
]

mediant_tests = [
    [0.1, 9, False, 0, 1, 9],
    [0.2, 9, False, 0, 1, 5],
    [0.3, 9, False, 0, 2, 7],
    [0.4, 9, False, 0, 2, 5],
    [0.5, 9, False, 0, 1, 2],
    [0.6, 9, False, 0, 3, 5],
    [0.7, 9, False, 0, 5, 7],
    [0.8, 9, False, 0, 4, 5],
    [0.9, 9, False, 0, 8, 9],
    [1.0, 9, False, 0, 1, 1],
    [1.0, 9, True, 1, 0, 1],
    [1.7, 9, True, 1, 5, 7],
    [1.7, 9, False, 0, 12, 7]
]


def test_mediant_tenths():
    for t in mediant_tests:
        assert frac.med(t[0], t[1], t[2]) == [t[3], t[4], t[5]]


def make9(q):
    S = str
    if q[0] or q[1]:
        qq = (S(q[0]) if q[0] else "")
        qq += " "
        qq += ("/".join([S(q[1]), S(q[2])]) if q[1] else "   ")
        return qq
    else:
        return "0    "


def make99(q):
    S = str
    if q[0] or q[1]:
        qq = (S(q[0]) if q[0] else "")
        qq += " "
        if q[1]:
            if q[1] < 10:
                qq += " "
            qq += ("/".join([S(q[1]), S(q[2])]))
            if q[2] < 10:
                qq += " "
        else:
            qq += "     "
        return qq
    else:
        return "0      "


def make999(q):
    S = str
    if q[0] or q[1]:
        qq = (S(q[0]) if q[0] else "")
        qq += " "
        if q[1]:
            if q[1] < 10:
                qq += "  "
            elif q[1] < 100:
                qq += " "
            qq += "/".join([S(q[1]), S(q[2])])
            if q[2] < 10:
                qq += "  "
            elif q[2] < 100:
                qq += " "
        else:
            qq += "       "
        return qq
    else:
        return "0        "


def xlline(o, j, m, w):
    for i in xrange(j*w, min(m-3, (j+1) * w)):
        d = o[i].split("\t")
        dd = float(d[0])
        assert make9(frac.cont(dd, 9, True)) == d[1]
        assert make99(frac.cont(dd, 99, True)) == d[2]
        assert make999(frac.cont(dd, 999, True)) == d[3]


def parsexl(f, w):
    oo = open(f)
    d = oo.readlines()
    o = filter(lambda x: len(x) > 0, map(lambda x: x.strip("\n"), d))
    m = len(o)-3
    for j in xrange(int(m/w)):
        xlline(o, j, m, w)


@pytest.mark.parametrize("filename,step", xltestfiles)
def test_file(filename, step):
    parsexl('./test_files/' + filename, step)
