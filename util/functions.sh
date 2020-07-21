#! /bin/bash

function assertInstalled() {
  for var in "$@"; do
    if ! command -v $var &> /dev/null; then
      echo "ERROR: '$var' is not installed... Please install this to continue."
      exit 1
    fi
  done
}