#!/usr/bin/env bash

set -e

lint () {
    while read filename; do
        echo "linting $filename"
        ocp-indent -i $filename
    done
}

compile () {
    echo "compiling ./$1/$2.ml"
    cd $1/
    ocamlfind ocamlopt \
        -linkpkg -g utils.ml data.ml $2.ml \
        -o $2
    ./$2 $3 $4 $5 $6
}

main () {
    find . -type f -name "*.ml" | lint
    compile src riemann 11 "minor" 25 1
}

main
