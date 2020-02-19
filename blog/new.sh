#!/bin/bash
DIR=$(realpath $(dirname $0))
DATE=`date +%Y-%m-%d`
for TRAIL in a b c d e f g h; do
	FILE="$DIR/$DATE-$TRAIL.md"
	if [ ! -e "$FILE" ]; then
		echo "# $DATE" >$FILE
		exec $EDITOR $FILE
	fi
done
echo "Can't decide on a filename."
exit 1
