#!/bin/sh

rm units/x86_64-freebsd/*

/data/devel/fpc-2.6.4/x86_64-freebsd/bin/fpc \
  -O2 -XX -Xs \
  -Mobjfpc -Sh -Fcutf8 \
  -FUunits/x86_64-freebsd \
  -Fu${PWD}/lib/common/* \
  -Fu${PWD}/lib/common/kernel/linux \
  -Fi${PWD}/lib/common/kernel \
  -o./mseide.freebsd.elf \
  apps/ide/mseide.pas

