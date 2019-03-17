#!/usr/bin/env bash

set -e

cd src/

filename="riemann"

ocamlfind ocamlopt \
    -linkpkg -g $filename.ml \
    -o $filename

./$filename

cd ../
