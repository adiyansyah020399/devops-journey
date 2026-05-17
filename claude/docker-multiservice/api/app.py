from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import mysql.connector

def get_skills():
    try:
        conn = mysql.connector.connect(
            host="db",
            user="devops",
            password="devops123",
            database="devopsdb"
        )
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM skills")
        skills = cursor.fetchall()
        conn.close()
        return skills
    except Exception as e:
        return {"error": str(e)}

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()

        if self.path == '/skills':
            data = get_skills()
        else:
            data = {
                "status": "ok",
                "service": "DevOps API",
                "endpoints": ["/skills"]
            }

        self.wfile.write(json.dumps(data).encode())

    def log_message(self, format, *args):
        pass

print("API Server running on port 5000")
HTTPServer(('0.0.0.0', 5000), Handler).serve_forever()
