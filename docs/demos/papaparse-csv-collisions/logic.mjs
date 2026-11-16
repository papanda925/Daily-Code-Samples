export const initial='id,name,name\n101,"東京,本社","OK"\n102,大阪,確認中';
export function duplicates(headers){const seen=new Set(),dup=new Set();for(const h of headers){if(seen.has(h))dup.add(h);seen.add(h);}return [...dup];}
export function safeCount(rows){return rows.filter(row=>Array.isArray(row)&&row.length>0).length;}