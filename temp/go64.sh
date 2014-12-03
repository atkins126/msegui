#!/bin/sh

/opt/fpc-2.5.1/x86_64-linux/bin/ppcx64 \
  -O1 -OpATHLON64 -XX -B -Xs -ve \
  -FUunits/x86_64-linux \
  -Fu${PWD}/lib/common/* -Fu${PWD}/lib/common/kernel/i386-linux \
  -Fi${PWD}/lib/common/kernel \
  -o./mseide.elf \
  apps/ide/mseide.pas

