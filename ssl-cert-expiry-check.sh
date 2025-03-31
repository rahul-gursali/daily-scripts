#!/bin/bash
openssl s_client -connect example.com:443 -servername example.com 2>/dev/null | openssl x509 -noout -dates
