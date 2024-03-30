#!/bin/bash

#Constants
DISPLAY_RE="([0-9]+)x([0-9]+)\\+([0-9]+)\\+([0-9]+)" # Regex to find display dimensions
FOLDER=`dirname "$BASH_SOURCE"` # Current folder
CACHE_FOLDER="$FOLDER"/img/cache/ # Cache folder
if ! [ -e $CACHE_FOLDER ]; then
    mkdir -p $CACHE_FOLDER
fi

#Passed arguments
while getopts ":i:a:" opt; do
    case $opt in
        i) arg_image="$OPTARG"
        ;;
        a) lock_args="$OPTARG"
        ;;
        \?) echo "Invalid option -$OPTARG" >&2 && exit 1
        ;;
    esac
done

#Image paths
if [ "$arg_image" ]; then
    BKG_IMG="$arg_image"  # Passed image
else
    BKG_IMG="$FOLDER/img/background.png"  # Default
fi

if ! [ -e "$BKG_IMG" ]; then
    echo "No background image! Exiting..."
    exit 2
fi

MD5_BKG_IMG=$(md5sum $BKG_IMG | cut -c 1-10)
MD5_SCREEN_CONFIG=$(xrandr | md5sum - | cut -c 1-32) # Hash of xrandr output
OUTPUT_IMG="$CACHE_FOLDER""$MD5_SCREEN_CONFIG"."$MD5_BKG_IMG".png # Path of final image
OUTPUT_IMG_WIDTH=0 # Decide size to cover all screens
OUTPUT_IMG_HEIGHT=0 # Decide size to cover all screens

# Enable DPMS on lock
on_lock() {
    xset +dpms dpms 5
}

# Disable DPMS on unlock
on_unlock() {
    xset dpms 0 0 0
}

# Make sure if the script is killed, DPMS settings are still reverted
trap on_unlock HUP INT TERM

ICON="$FOLDER/img/lock.png"

#i3lock command
ring=9e5c967f
inside=00000000

ringver=3841a17f
insidever=00000000

ringwrong=9f202d7f
insidewrong=6134327f

keyhl=e77cdb7f
bshl=582da37f

LOCK_BASE_CMD="i3lock -i '$OUTPUT_IMG' --verif-text='' --wrong-text='' \
--noinput-text='' --inside-color=$inside --ring-color='$ring' \
--insidever-color='$insidever' --ringver-color='$ringver' \
--insidewrong-color='$insidewrong' --ringwrong-color='$ringwrong' \
--keyhl-color='$keyhl' --bshl-color='$bshl' --line-color=00000000 \
--separator-color=0000007f --radius 130 --ring-width 3"
if [ "$lock_args" ]; then
        LOCK_ARGS="$lock_args"  # Passed command
else
        LOCK_ARGS="-e -n"  # Default
fi
LOCK_CMD="on_lock; $LOCK_BASE_CMD $LOCK_ARGS; on_unlock"

if [ -e $OUTPUT_IMG ]
then
    # Lock screen since image already exists
    eval $LOCK_CMD &
    exit 0
fi

#Execute xrandr to get information about the monitors:
while read LINE
do
  #If we are reading the line that contains the position information:
  if [[ $LINE =~ $DISPLAY_RE ]]; then
    #Extract information and append some parameters to the ones that will be given to ImageMagick:
    SCREEN_WIDTH=${BASH_REMATCH[1]}
    SCREEN_HEIGHT=${BASH_REMATCH[2]}
    SCREEN_X=${BASH_REMATCH[3]}
    SCREEN_Y=${BASH_REMATCH[4]}
    
    CACHE_IMG="$CACHE_FOLDER""$SCREEN_WIDTH"x"$SCREEN_HEIGHT"."$MD5_BKG_IMG".png
    ## if cache for that screensize doesnt exist
    if ! [ -e $CACHE_IMG ]
    then
	# Create image for that screensize
        convert "$BKG_IMG" -resize "${SCREEN_WIDTH}X${SCREEN_HEIGHT}^" -gravity "Center" -crop "${SCREEN_WIDTH}X${SCREEN_HEIGHT}+0+0" +repage "$CACHE_IMG"
        # Place lock icon at centre of each screen
        convert "$CACHE_IMG" -type TrueColor "$ICON" -gravity center -composite -matte "$CACHE_IMG"
    fi

    # Decide size of output image
    if (( $OUTPUT_IMG_WIDTH < $SCREEN_WIDTH+$SCREEN_X )); then
      OUTPUT_IMG_WIDTH=$(($SCREEN_WIDTH+$SCREEN_X));
    fi;
    if (( $OUTPUT_IMG_HEIGHT < $SCREEN_HEIGHT+$SCREEN_Y )); then
      OUTPUT_IMG_HEIGHT=$(( $SCREEN_HEIGHT+$SCREEN_Y ));
    fi;

    PARAMS="$PARAMS -type TrueColor $CACHE_IMG -geometry +$SCREEN_X+$SCREEN_Y -composite "
  fi
done <<<"`xrandr`"

#Execute ImageMagick:
eval convert -size ${OUTPUT_IMG_WIDTH}x${OUTPUT_IMG_HEIGHT} 'xc:black' $OUTPUT_IMG
eval convert $OUTPUT_IMG $PARAMS $OUTPUT_IMG

#Lock the screen:
eval $LOCK_CMD &
