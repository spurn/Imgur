#!/bin/bash

#############################
#   Downloades all albums from file album
#############################

while read line
do
	id=$line
	blog='/layout/blog'
	url=$id$blog
	echo "Downloading $url"
	echo "---"
	#url="http://imgur.com/a/M3tYX"
	dir=$(echo "$url" |sed 's/http:\/\/imgur.com\/a\///g'| sed 's/\/layout\/blog//g')
	if [ -e $dir ]; then
		cd $dir
	else
		mkdir $dir
		cd $dir
	fi
	wget -q "$url"
	dir='blog'
	cat $dir | grep  'i.imgur.com'| grep -v 'cdnUrl'|\
	cut -d\" -f2 |grep '.com'| grep -v 'api.imgur'|\
	sed 's/\?[0-9]//g'|\
	while read id2;
	do
		id3=$(echo "$id2" |sed 's/\/\/i.imgur.com\///g')
		if [ -f $id3 ]; then
			echo "$id3 exists"
		else
			echo "Downloading2 http:$id2";
			wget -q -c "http:$id2";
		fi
	done;
	ls 
	rm -f blog
	cd ..
	echo "---------------------------------------------------"
done <album
