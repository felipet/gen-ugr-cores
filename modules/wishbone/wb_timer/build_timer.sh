#!/bin/bash

PJR_NAME="wb_timer"
SOURCE="timer"

if [ $1 == "clean" ];then
    rm -rf doc
    rm -f ${PJR_NAME}_slave.vhd
    rm -f ${PJR_NAME}_wbgen2_pkg.vhd
    exit 0
fi

mkdir -p doc
wbgen2 -D ./doc/${PJR_NAME}.html -V ${PJR_NAME}_slave.vhd --cstyle struct --lang vhdl -p ${PJR_NAME}_wbgen2_pkg.vhd --hstyle record ${SOURCE}.wb
