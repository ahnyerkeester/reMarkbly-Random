#!/bin/sh
# Branched from https://github.com/Neurone/reMarkable
# This scrip will select a random pic from:
#   /home/root/customization/images/suspended
#   and place it as the current sleep screen at:
#   /usr/share/remarkable/suspended.png

SUSPENDED_IMAGES_DIR=/home/root/customization/images/suspended
SUSPENDED_FILE=/usr/share/remarkable/suspended.original.png
if [ -d $SUSPENDED_IMAGES_DIR ]; then
    SUSPENDED_IMAGES_COUNT=$(ls $SUSPENDED_IMAGES_DIR | wc -l)
    if [ $SUSPENDED_IMAGES_COUNT -ne 0 ]; then
        SUSPENDED_FILE=$(shuf -n1 -e $SUSPENDED_IMAGES_DIR/*)
    fi;
fi
cp $SUSPENDED_FILE /usr/share/remarkable/suspended.png
