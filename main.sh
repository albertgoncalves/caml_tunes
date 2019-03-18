#!/usr/bin/env bash

set -e

indent () {
    while read filename; do
        echo "ocp-indenting $filename"
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
    find . -type f -name "*.ml" | indent
    compile src riemann 11 "minor" 25 1
}

main
