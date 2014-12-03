#!/bin/sh
find ./lib \( -name '*.o' -o -name '*.ppu' -o -name '*.a' -o -name '*.rst' -o -name '*.bak' -o -name '*.bak1' \) -exec rm {} \+
#find ./apps \( -name '*.o' -o -name '*.ppu' -o -name '*.a' -o -name '*.rst' \) -exec rm {} \+


