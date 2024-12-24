#!/bin/bash

./kill_vapor.sh

file="db.sqlite"
echo "Deleting database..."
if [ -f "$file" ] ; then
    rm "$file"
    echo "Database deleted"
fi

echo "Deleting Public files..."
rm -rf Public/*

echo "Running database migration..."
swift run App migrate

echo "Running app..."
swift run App serve --hostname 0.0.0.0 --port 80
