#!/bin/sh

# -vi -O2 -CX -XX -B 

# NOTE:
#  -CX had to be removed or I get linking error
#  -O1 had to be used instead or I get compiler error
#  -B  build all units
#  -O2 good optimization
#  -O- no optimization (best for debugging)

#   -OpATHLON64 \

#rm ./mseidefp
rm units/i386-linux/*

/home/graemeg/programming/fpc-2.4.0/bin/fpc \
  -ve -Xs \
  -O2- \
  -FUunits/i386-linux/ \
  -Fi${PWD}/lib/common/kernel \
  -Fu${PWD}/lib/common/kernel/ -Fu${PWD}/lib/common/db \
  -Fu${PWD}/lib/common/designutils/ -Fu${PWD}/lib/common/dialogs \
  -Fu${PWD}/lib/common/editwidgets/ -Fu${PWD}/lib/common/i18n \
  -Fu${PWD}/lib/common/ifi/ -Fu${PWD}/lib/common/image \
  -Fu${PWD}/lib/common/opengl/ -Fu${PWD}/lib/common/pascalscript \
  -Fu${PWD}/lib/common/printer/ -Fu${PWD}/lib/common/regcomponents \
  -Fu${PWD}/lib/common/report/ -Fu${PWD}/lib/common/serialcomm \
  -Fu${PWD}/lib/common/sysutils/ -Fu${PWD}/lib/common/unicode \
  -Fu${PWD}/lib/common/math/ \
  -Fu${PWD}/lib/common/widgets/ \
  -Fu${PWD}/lib/common/kernel/i386-linux \
  -dmse_withoutdb -o./mseide.elf32 apps/ide/mseide.pas

