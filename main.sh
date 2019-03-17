#!/usr/bin/env bash

set -e

lint () {
    while read filename; do
        echo "linting $filename"
        ocp-indent -i $filename
    done
}

compile () {
    cd $1
    filename="riemann"
    ocamlfind ocamlopt \
        -linkpkg -g utils.ml data.ml $filename.ml \
        -o $filename
    ./$filename
}

main () {
    find . -type f -name "*.ml" | lint
    compile src/
}

main
