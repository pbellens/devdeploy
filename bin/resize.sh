#!/bin/bash

for f in "$@"; do
  fullp=$(readlink -f "${f}")
  file=$(basename -- "$f")
  extension="${filename##*.}"
  filename="${filename%.*}"
 
  convert -strip -interlace Plane -gaussian-blur 0.05 -quality 85% "${fullp}" "${filename}_resized.${extension}"
