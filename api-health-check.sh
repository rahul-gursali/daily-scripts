# API health check
#!/bin/bash
curl -s -o /dev/null -w "%{http_code}" http://api.example.com/health
