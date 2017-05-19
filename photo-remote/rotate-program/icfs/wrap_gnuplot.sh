#!/bin/sh
file="$1"

gnuplot <<GPLOT
set output "$file.svg"
set term svg
plot "$file" using 2:3:5:6 with vectors title "$file"
GPLOT


