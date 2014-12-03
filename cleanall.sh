#!/bin/sh
find ./lib \( -name '*.o' -o -name '*.ppu' -o -name '*.a' \) -exec rm {} \+
find ./apps \( -name '*.o' -o -name '*.ppu' -o -name '*.a' \) -exec rm {} \+


