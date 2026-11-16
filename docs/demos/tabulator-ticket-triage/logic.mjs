// ブラウザーのみで利用する架空の障害チケット。通信・永続保存はしません。
export const INITIAL_TICKETS = Object.freeze([
 {id:101,service:"ネットワーク",summary:"DNS応答が不安定",priority:"高",status:"対応中",minutes:45},
 {id:102,service:"メール",summary:"検索が一部遅い",priority:"中",status:"調査中",minutes:25},
 {id:103,service:"Web",summary:"画像読込みが遅い",priority:"低",status:"完了",minutes:35},
 {id:104,service:"ネットワーク",summary:"VPN接続できない",priority:"高",status:"未対応",minutes:70},
 {id:105,service:"認証",summary:"テスト端末で認証失敗",priority:"高",status:"調査中",minutes:55},
 {id:106,service:"メール",summary:"テスト通知が二重",priority:"低",status:"完了",minutes:20},
 {id:107,service:"Web",summary:"ログイン表示の崩れ",priority:"中",status:"対応中",minutes:40},
 {id:108,service:"認証",summary:"権限表示の確認",priority:"中",status:"未対応",minutes:15}
]);
export function freshTickets(){return INITIAL_TICKETS.map(ticket=>({...ticket}));}
export function matches(ticket,priority="",keyword=""){
 const term=String(keyword).trim().toLocaleLowerCase("ja-JP");
 const field=[ticket.service,ticket.summary,ticket.status,String(ticket.id)].join(" ").toLocaleLowerCase("ja-JP");
 return (!priority || ticket.priority===priority) && (!term || field.includes(term));
}
export function summary(items){return {count:items.length,minutes:items.reduce((n,t)=>n+Number(t.minutes||0),0)};}
