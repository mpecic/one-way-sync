#!/usr/bin/env bash

if [ -z "$1" -o -z "$2" ]; then
	echo "Usage: sync.sh [src] [dst]"
	exit 1;
fi

if [ ! -d $1 ]; then
	echo "Error: $1 is not a directory"
	exit 2;
elif [ ! -d $2 ]; then
	echo "Error: $2 is not a directory"
	exit 2;
fi

srclen=$((${#1}+1))
dstlen=$((${#2}+1))

tmp=$(date +%s)
find $1 -type f -printf "%f;%s;%h\n" > /tmp/sync$tmp.src
find $2 -type f -printf "%f;%s;%h\n" > /tmp/sync$tmp.dst

while IFS=";" read -r name size path
do
	line=$(grep -n -m 1 "$name;$size;" /tmp/sync$tmp.dst)
	srcpath=$(echo $path | cut -c $srclen-)
	if [ -z "$line" ]; then
		if [ ! -d "$2$srcpath" ]; then
			echo "mkdir -p $2$srcpath"
		fi
		echo "cp $path/$name $2$srcpath/$name"
	else
		linenum=$(echo $line | cut -d ':' -f 1)
		dstpath=$(echo $line | cut -d ';' -f 3 | cut -c $dstlen-)
		if [ "$srcpath" != "$dstpath" ]; then
			if [ ! -d "$2$srcpath" ]; then
				echo "mkdir -p $2$srcpath"
			fi
			echo "mv $2$dstpath/$name $2$srcpath/$name"
		fi
		sed -i "${linenum}d" /tmp/sync$tmp.dst
	fi
done < /tmp/sync$tmp.src

while IFS=";" read -r name size path
do
	echo "rm $path/$name"
done < /tmp/sync$tmp.dst

rm /tmp/sync$tmp.src /tmp/sync$tmp.dst
