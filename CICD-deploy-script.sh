#!/bin/bash
cd /var/www/app
git pull origin main
npm install
systemctl restart app.service

# Script to automates the process of updating and restarting a web application #
