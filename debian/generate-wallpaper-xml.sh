#!/bin/bash

WALLPAPER_DIR="usr/share/backgrounds"
CONFIG_DIR="debian/deepin-gtk-theme/usr/share/gnome-background-properties"
XML_FILE="$CONFIG_DIR/deepin-wallpapers.xml"

[[ -d ${WALLPAPER_DIR} ]] || exit 0
[[ -d ${CONFIG_DIR} ]] || mkdir -p ${CONFIG_DIR}

#### Count the number of jpg/jpeg/png images. ####
numfiles=`ls -1 $WALLPAPER_DIR/*.jpg $WALLPAPER_DIR/*.jpeg $WALLPAPER_DIR/*.png 2>/dev/null | wc -l`

#### If there are no image files there then exit. ####
if [[ $numfiles -eq 0 ]]; then
    echo "**** The wallpaper directory \"$WALLPAPER_DIR\" has no images. ****"
    echo "**** Precedure Terminated. ****"
    exit 1
fi

generate_image_name() {
    echo $@ | sed -e 's/_/ /g;s/ ./\U&\E/g;s/^./\U&\E/g'
}

cat <<EOF > $XML_FILE
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
<wallpapers>
EOF

#ls -1 $WALLPAPER_DIR/*.jpg $WALLPAPER_DIR/*.png $WALLPAPER_DIR/*.jpeg 2> /dev/null |
#while read image_name; do
for filename in $WALLPAPER_DIR/*.jpg $WALLPAPER_DIR/*.png $WALLPAPER_DIR/*.jpeg; do
   iname=$(basename "$filename")
   iname=$(generate_image_name ${iname%%\.*})
   echo "   Adding: ${iname} ($filename)."
   echo "  <wallpaper>"                          >> $XML_FILE
   echo "    <name>$iname</name>"                 >> $XML_FILE
   echo "    <filename>/$filename</filename>"   >> $XML_FILE
   echo "    <options>zoom</options>"            >> $XML_FILE
   echo "    <pcolor>#c58357</pcolor>"           >> $XML_FILE
   echo "    <scolor>#c58357</scolor>"           >> $XML_FILE
   echo "    <shade_type>solid</shade_type>"     >> $XML_FILE
   echo "  </wallpaper>"                         >> $XML_FILE
done

echo "</wallpapers>"                             >> $XML_FILE

