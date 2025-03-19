#!/bin/sh
#
# set-random-sleep.sh with detection
#
# Branched and significantly expanded from
# https://github.com/Neurone/reMarkable
#
# This scrip will randomly order the pics in:
#   /home/root/customization/images/suspended
# Then, every time it runs, it checks to see if
#  the images in the folder have changed. If not,
#  it will select the next pic in order and set
#  it as the current sleep screen at:
#    /usr/share/remarkable/suspended.png
#
# However, if it detects a change in the folder,
#  it will reindex them and then set the next one
# as the current sleep screen.

SUSPENDED_IMAGES_DIR=/home/root/customization/images/suspended
ORDER_FILE=/home/root/customization/.image_order
INDEX_FILE=/home/root/customization/.image_index
CHECKSUM_FILE=/home/root/customization/.image_checksum

calculate_checksum() {
    find "$SUSPENDED_IMAGES_DIR" -type f -exec md5sum {} + | sort -k 2 | md5sum | awk '{print $1}'
}

shuffle_images() {
    ls "$SUSPENDED_IMAGES_DIR"/* > "$ORDER_FILE"
    shuf "$ORDER_FILE" -o "$ORDER_FILE"
    echo 0 > "$INDEX_FILE"
    calculate_checksum > "$CHECKSUM_FILE"
}

update_image() {
    TOTAL_IMAGES=$(wc -l < "$ORDER_FILE")
    CURRENT_INDEX=$(cat "$INDEX_FILE")

    if [ "$CURRENT_INDEX" -ge "$TOTAL_IMAGES" ]; then
        shuffle_images
        CURRENT_INDEX=0
    fi

    SUSPENDED_FILE=$(sed -n "$((CURRENT_INDEX + 1))p" "$ORDER_FILE")
    cp "$SUSPENDED_FILE" /usr/share/remarkable/suspended.png

    echo $((CURRENT_INDEX + 1)) > "$INDEX_FILE"
}

# Ensure the directory exists
if [ ! -d "$SUSPENDED_IMAGES_DIR" ]; then
    echo "Image directory does not exist. Exiting."
    exit 1
fi

# Check for changes since last run
NEW_CHECKSUM=$(calculate_checksum)
if [ ! -f "$CHECKSUM_FILE" ] || [ "$NEW_CHECKSUM" != "$(cat $CHECKSUM_FILE)" ]; then
    echo "Changes detected in the image directory, reindexing..."
    shuffle_images
else
    echo "No changes detected. Using existing order."
fi

# Update image
update_image
