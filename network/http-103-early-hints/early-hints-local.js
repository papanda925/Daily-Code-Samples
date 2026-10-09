// Node.js >=18.11, HTTP/1.1 only, local demo. Does not expose port externally.
const http = require("node:http");
const server = http.createServer((req, res) => {
  if (req.url === "/style.css") {
    res.writeHead(200, {"content-type": "text/css; charset=utf-8"});
    res.end("body { color: navy; }");
    return;
  }
  if (req.url !== "/") {
    res.writeHead(404);
    res.end("not found");
    return;
  }
  res.writeEarlyHints({
    link: "</style.css>; rel=preload; as=style",
  });
  setTimeout(() => {
    res.writeHead(200, {
      "content-type": "text/html; charset=utf-8",
      link: "</style.css>; rel=preload; as=style",
    });
    res.end('<!doctype html><link rel="stylesheet" href="/style.css"><h1>hello</h1>');
  }, 700);
});
server.listen(30031, "127.0.0.1", () =>
  console.log("local demo: http://127.0.0.1:30031/")
);
