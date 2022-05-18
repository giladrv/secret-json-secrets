#!/bin/bash
set -euo pipefail
git push --delete origin $1
git tag -d $1
