#!/bin/bash

echo "Running database migration..."
swift run App migrate

echo "Running app..."
swift run App serve --hostname 0.0.0.0 --port 80
