#!/bin/bash

VERSION=$(cat version)
TARGET=${1-'orangepizero'}

echo "Build for ${VERSION}-[${TARGET}]"

echo "Clone..."
git clone --depth 1 https://github.com/armbian/build

echo "Patch..."
cp customize-image.sh build/userpatches/customize-image.sh
cp -r overlay/* build/userpatches/overlay
[ -e Vagrant.custom ] && echo "Copy custom Vagrant file" && cp Vagrant.custom build/Vagrant
cd build

echo "Ensure vagrant halted..."
vagrant halt -f

echo "Ensure vagrant destroyed..."
vagrant destroy -f

echo "Build..."
vagrant up && \
vagrant ssh -c \
"cd armbian && \
./compile.sh \
CLEAN_LEVEL='make,debs' \
BRANCH=next \
BOARD=${TARGET} \
KERNEL_ONLY=no \
RELEASE=jessie \
KERNEL_CONFIGURE=no \
BUILD_DESKTOP=no \
PROGRESS_DISPLAY=plain" > octopio_build.log

cd output/images
for f in $(ls Armbian*.img)
do
        NAME=${f}
        NEWNAME=$(echo $NAME | sed -e "s/Armbian/Octopio-${VERSION}-[${TARGET}]-/")
        mv $NAME $NEWNAME
	zip ${NEWNAME}.zip ${NEWNAME}
done
