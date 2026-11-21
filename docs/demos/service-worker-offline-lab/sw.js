const CACHE="dailycode-offline-lab-v1";const FILES=["./","./index.html","./app.js","../_shared/interactive-lab.css"];
self.addEventListener("install",event=>{event.waitUntil(caches.open(CACHE).then(cache=>cache.addAll(FILES)));self.skipWaiting();});
self.addEventListener("activate",event=>{event.waitUntil(self.clients.claim());});
self.addEventListener("fetch",event=>{const req=event.request;if(req.method!=="GET"||new URL(req.url).origin!==self.location.origin)return;event.respondWith(caches.match(req).then(hit=>hit||fetch(req)));});