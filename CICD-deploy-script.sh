#!/bin/bash
cd /var/www/app
git pull origin main
npm install
systemctl restart app.service
