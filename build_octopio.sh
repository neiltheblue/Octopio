#!/bin/bash

echo "Clone..."
git clone --depth 1 https://github.com/armbian/build

echo "Patch..."
cp customize-image.sh build/userpatches/customize-image.sh
cd build

echo "Ensure vagrant halted..."
vagrant halt -f

echo "Ensure vagrant destroyed..."
vagrant destroy -f

echo "Build..."
vagrant up && \
vagrant ssh -c \
'cd armbian && \
./compile.sh \
CLEAN_LEVEL="make,debs,images" \
BRANCH=default \
BOARD=orangepizero \
KERNEL_ONLY=no \
RELEASE=jessie \
KERNEL_CONFIGURE=no \
BUILD_DESKTOP=no \
PROGRESS_DISPLAY=plain'

for f in $(ls output/images/*)
do
        NAME=${f}
        NEWNAME=$(echo $NAME | sed -e 's/Armbian/Octopio/')
        mv $NAME $NEWNAME
done
