var frac = function(x, D, mixed) {
    var n1 = Math.floor(x), d1 = 1;
    var n2 = n1+1, d2 = 1;
    if(x !== n1) while(d1 <= D && d2 <= D) {
        var m = (n1 + n2) / (d1 + d2);
        if(x === m) {
            if(d1 + d2 <= D) d1+=d2, n1+=n2, d2=D+1;
            else if(d1 > d2) d2=D+1;
            else d1=D+1;
            break;
        }
        else if(x < m) n2 = n1+n2, d2 = d1+d2;
        else n1 = n1+n2, d1 = d1+d2;
    }
    if(d1 > D) d1 = d2, n1 = n2;
    if(!mixed) return [0, n1, d1];
    var q = Math.floor(n1/d1);
    return [q, n1 - q*d1, d1];
};
if(typeof module !== undefined) module.exports = frac;
