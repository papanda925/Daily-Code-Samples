export const usage=[48,73,84,69,91,56,67];
export const days=["月","火","水","木","金","土","日"];
export function alertDays(threshold,values=usage){return values.filter(v=>v>Number(threshold)).length;}
export function maxUsage(values=usage){return Math.max(...values);}