#!/bin/bash
set -e

GOMAXPROCS=1 go test -tags=embed -timeout 900s `go list ./... | grep -v pdserver`
GOMAXPROCS=4 go test -tags=embed -timeout 900s -race `go list ./... | grep -v pdserver`

# no tests, but a build is something
for dir in $(find apps tools -maxdepth 1 -type d) ; do
    if grep -q '^package main$' $dir/*.go 2>/dev/null; then
        echo "building $dir"
        go build -tags=embed -o $dir/$(basename $dir) ./$dir
    else
        echo "(skipped $dir)"
    fi
done
