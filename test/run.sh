#!/bin/bash
cd "$(dirname "$0")"
go mod init terraform-static-website-test
go mod tidy -v
go get .
go test -v