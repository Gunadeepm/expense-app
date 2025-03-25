#!/bin/bash

# configuring the reverse proxy

proxy_http_version 1.1;

location /api/ { proxy_pass http://localhost:8080/; }

location /health {
stub_status on;
access_log off;
}
