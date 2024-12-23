#!/bin/bash

echo "Finding app PID to stop..."
kill -9 $(lsof -t -i :8080)
echo "Vapor server stopped."
