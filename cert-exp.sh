#!/bin/bash

# https://r4uch.com/export-traefik-certificates/

# Requirements: you will need to install jq and maybe openssl
# Usage: sudo cert-exp.sh

set -e # abort on errors
set -u # abort on unset variables

. .env

SRC=${SRC:-$DCAPE_ROOT/var/traefik/acme.json}
OUT=${OUT:-ssl/}

# creates a directory for all of your certificates
mkdir -p $OUT

# reads the acme.json file, please put this file in the same directory as your script
json=$(cat $SRC)

export_cer_key () {
    echo $json | jq -r '.[].Certificates[] | select(.domain.main == "'$1'") | .certificate' | base64 -d > $OUT$1.crt
    echo $json | jq -r '.[].Certificates[] | select(.domain.main == "'$1'") | .key' | base64 -d > $OUT$1.key
}

# iterates through all of your domains
for domain in $(echo $json | jq -r '.[].Certificates[].domain.main')
do
    export_cer_key "$domain"
done
