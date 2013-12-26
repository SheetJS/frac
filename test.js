var fs = require('fs'), assert = require('assert');
var frac;
describe('source', function() { it('should load', function() { frac = require('./'); }); });

function line(o,j,m) {
    it(j, function(done) {
        var d, q, qq;
        for(var i = j*100; i < m-3 && i < (j+1)*100; ++i) {
            d = o[i].split("\t");

            q = frac.cont(Number(d[0]), 9, true);
            qq = (q[0]||q[1]) ? (q[0] || "") + " " + (q[1] ? q[1] + "/" + q[2] : "   ") : "0    ";
            assert.equal(qq, d[1], d[1] + " 1");

            q = frac.cont(Number(d[0]), 99, true);
            qq = (q[0]||q[1]) ? (q[0] || "") + " " + (q[1] ? (q[1] < 10 ? " " : "") + q[1] + "/" + q[2] + (q[2]<10?" ":"") : "     ") : "0      ";
            assert.equal(qq, d[2], d[2] + " 2");

            q = frac.cont(Number(d[0]), 999, true);
            qq = (q[0]||q[1]) ? (q[0] || "") + " " + (q[1] ? (q[1] < 100 ? " " : "") + (q[1] < 10 ? " " : "") + q[1] + "/" + q[2] + (q[2]<10?" ":"") + (q[2]<100?" ":""): "       ") : "0        ";
            assert.equal(qq, d[3], d[3] + " 3");
        }
        done();
    });
}
function parsetest(o) {
    for(var j = 0, m = o.length-3; j < m/100; ++j) line(o,j,m);
}
describe('xl.00001.tsv', function() {
    var o = fs.readFileSync('./test_files/xl.00001.tsv', 'utf-8').split("\n");
    parsetest(o);
});
