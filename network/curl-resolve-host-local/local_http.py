#!/usr/bin/env python3
"""Local-only HTTP responder to demonstrate curl --resolve; Ctrl+C to exit."""
from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        body = f"Path: {self.path}\nHost: {self.headers.get('Host')}\n"
        encoded = body.encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Length", str(len(encoded)))
        self.end_headers()
        self.wfile.write(encoded)

server = HTTPServer(("127.0.0.1", 39123), Handler)
print("Listening on 127.0.0.1:39123; Ctrl+C to exit", flush=True)
try:
    server.serve_forever()
except KeyboardInterrupt:
    print("Stopped")
finally:
    server.server_close()
