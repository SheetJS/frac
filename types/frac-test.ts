import frac from 'frac';

type RV = [number, number, number];
const x1: RV = frac(1.3, 9);
const x2: RV = frac(1.3, 9, true);
const x3: RV = frac(-1.3, 9);
const x4: RV = frac(-1.3, 9, true);

const y1: RV = frac.cont(1.3, 9);
const y2: RV = frac.cont(1.3, 9, true);
const y3: RV = frac.cont(-1.3, 9);
const y4: RV = frac.cont(-1.3, 9, true);
