#!/bin/bash

echo "Clone..."
git clone --depth 1 https://github.com/armbian/build

echo "Patch..."
cp customize-image.sh armbian/build/userpatches/customize-image.sh
cd armbian/build

echo "Make sure halted..."
vagrant halt -f

echo "Make sure destroyed..."
vagrant destroy -f

echo "Build..."
vagrant up && \
vagrant ssh -c \
'cd armbian && \
sudo ./compile.sh \
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

