#!/bin/bash

# Custom build script for B⚡️LT Kernel

# Constants
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
cyan='\033[0;36m'
yellow='\033[0;33m'
blue='\033[0;34m'
default='\033[0m'

# Define variables
KERNEL_DIR=$PWD
ANYKERNEL_DIR=$KERNEL_DIR/anykernel/
DATE=$(date +"%d%m%Y")
TIME=$(date +"-%H.%M.%S")
KERNEL_NAME="B⚡️LT:Xtreme"
KERNEL_VERSION="3.10.108-"
DEVICE="-kenzo-"
FINAL_ZIP="$KERNEL_VERSION""$KERNEL_NAME""$DEVICE""$DATE""$TIME"

BUILD_START=$(date +"%s")

# Cleanup before
rm -rf $ANYKERNEL_DIR/*zip
rm -rf $ANYKERNEL_DIR/Image.gz-dtb
rm -rf out

echo -e "$green***********************************************"
echo  "           Compiling B⚡️LT Kernel              "
echo -e "***********************************************"

# Finally build it
mkdir out
make clean && make mrproper
make O=out ARCH=arm64 kenzo_defconfig
export KBUILD_BUILD_USER="genxinvenits X NotDheeraj06"
export KBUILD_BUILD_HOST="oxiizen.com"
export ARCH=arm64 && export SUBARCH=arm64 && export USE_CCACHE=1
export CROSS_COMPILE_ARM32=$HOME/Downloads/Android/TOOLS/gcc-linaro-6.5.0-2018.12-linux/bin/arm-linux-gnueabi-
make -j4 O=out kenzo_defconfig\ARCH=arm64

echo -e "$yellow***********************************************"
echo  "                 Zipping up                    "
echo -e "***********************************************"

# Create the flashable zip
cp out/arch/arm64/boot/Image.gz-dtb $ANYKERNEL_DIR
cd $ANYKERNEL_DIR
zip -r9 $FINAL_ZIP.zip * -x .git README.md *placeholder
mv *zip $HOME/Downloads/

echo -e "$cyan***********************************************"
echo  "            Cleaning up the junk files          "
echo -e "***********************************************$default"

# Cleanup again
cd ../
rm -rf $ANYKERNEL_DIR/Image.gz-dtb
rm -rf out
make clean && make mrproper

# Build complete
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$green Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$default"

