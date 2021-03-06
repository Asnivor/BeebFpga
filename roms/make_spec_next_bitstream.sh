#!/bin/bash

run_data2mem=$false

XILINX=/opt/Xilinx/14.7
DATA2MEM=${XILINX}/ISE_DS/ISE/bin/lin64/data2mem
IMAGE=tmp/rom_image.bin

# Build a fresh ROM image
./make_rom_image.sh

# Run bitmerge to merge in the ROM images
gcc -o tmp/bitmerge bitmerge.c 
./tmp/bitmerge ../xilinx/working/bbc_micro_spec_next.bit 80000:$IMAGE tmp/merged.bit
rm -f ./tmp/bitmerge

# Run data2mem to merge in the AVR Firmware
if [ $run_data2mem ]; then
BMM_FILE=../src/xilinx/CpuMon_bd.bmm
${DATA2MEM} -bm ${BMM_FILE} -bd ../AtomBusMon/firmware/avr_progmem.mem -bt tmp/merged.bit -o b tmp/merged2.bit
mv tmp/merged2.bit tmp/merged.bit
fi

mv tmp/merged.bit tmp/bbc_micro_spec_next.bit
