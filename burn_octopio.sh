#!/bin/bash

# burn_octopio.sh <src_image> <sd_device>

IMG=${1}
DEV=${2}
echo "Writing ${IMG} to ${DEV}"

ls -lh ${DEV} && \
read -p "Enter to continue..." && \
dd if=${IMG} of=${DEV} conv=sync status=progress
sync

