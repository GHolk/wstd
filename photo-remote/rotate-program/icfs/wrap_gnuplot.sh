#!/bin/sh
file="$1"

gnuplot <<GPLOT
set output "${file%%.txt}.svg"
set term svg
plot "$file" using 2:3:(\$5*10):(\$6*10) with vectors title "$file"
GPLOT


