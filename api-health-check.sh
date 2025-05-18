# API health check
#!/bin/bash
curl -s -o /dev/null -w "%{http_code}" http://api.example.com/health

# if the service is healthy, it might return a 200, but if the service is down, it might return a 500 or 404.
