#!/bin/bash

echo "Running database migration..."
swift run App migrate

echo "Running app..."
swift run