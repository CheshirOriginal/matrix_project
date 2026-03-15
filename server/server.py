from http.server import BaseHTTPRequestHandler, HTTPServer
import subprocess
import time

from prometheus_client import Counter, Histogram, Gauge, generate_latest

REQUESTS = Counter("matrix_requests_total", "Total matrix requests")
ERRORS = Counter("matrix_errors_total", "Total matrix errors")
PROCESS_TIME = Histogram("matrix_processing_seconds", "Matrix processing time")
ACTIVE = Gauge("matrix_active_requests", "Active matrix requests")


class Handler(BaseHTTPRequestHandler):

    def do_POST(self):
        if self.path != "/process":
            self.send_response(404)
            self.end_headers()
            return

        try:
            ACTIVE.inc()
            REQUESTS.inc()

            length = int(self.headers['Content-Length'])
            data = self.rfile.read(length).decode()

            start = time.time()

            result = subprocess.run(
                ["./matrix_app"],
                input=data,
                text=True,
                capture_output=True
            )

            PROCESS_TIME.observe(time.time() - start)

            self.send_response(200)
            self.end_headers()
            self.wfile.write(result.stdout.encode())

        except Exception as e:
            ERRORS.inc()
            self.send_response(500)
            self.end_headers()
            self.wfile.write(str(e).encode())

        finally:
            ACTIVE.dec()

    def do_GET(self):
        if self.path == "/metrics":
            metrics = generate_latest()
            self.send_response(200)
            self.end_headers()
            self.wfile.write(metrics)


server = HTTPServer(("0.0.0.0", 8080), Handler)

print("Server running on port 8080")

server.serve_forever()