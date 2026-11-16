export const axis=[0,1,2,3,4];
export function surface(scale){const n=Number(scale);if(!Number.isFinite(n)||n<1||n>3)throw new RangeError("倍率1〜3");return axis.map(y=>axis.map(x=>x*y*n));}
export function maximum(z){return Math.max(...z.flat());}