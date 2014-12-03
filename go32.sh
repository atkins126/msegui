#!/bin/sh
echo Current directory is ${PWD}

/opt/fpc_2.2.5/bin/ppc386 -Xd -Xr/usr/lib32/ -Fu${PWD}/lib/common/* \
  -Fu${PWD}/lib/common/kernel/i386-linux \
  -Fi${PWD}/lib/common/kernel \
  apps/ide/mseide.pas


