// Node.js 18+: no external requests. Starts an ephemeral localhost-only server.
const http = require("node:http");

async function main() {
  const server = http.createServer((_req, res) => {
    setTimeout(() => {
      if (!res.writableEnded) {
        res.writeHead(200, {"content-type": "text/plain"});
        res.end("finished");
      }
    }, 400);
  });
  server.listen(0, "127.0.0.1");
  await new Promise(resolve => server.once("listening", resolve));
  const url = `http://127.0.0.1:${server.address().port}/`;
  try {
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), 100);
    try {
      await fetch(url, {signal: controller.signal});
      console.log("Unexpectedly completed before abort");
      process.exitCode = 1;
    } catch (error) {
      if (error.name !== "AbortError") throw error;
      console.log("First request: AbortError (cancelled by client)");
    } finally {
      clearTimeout(timer);
    }

    const response = await fetch(url);
    console.log(`Second request: ${response.status} ${await response.text()}`);
  } finally {
    server.closeAllConnections?.();
    await new Promise(resolve => server.close(resolve));
  }
}

main().catch(error => { console.error(error); process.exitCode = 1; });
