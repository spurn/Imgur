#!/bin/bash

#############################
#   Downloades all albums from users specified in file albums
#############################

#set +m      # Deactiveate job control
#shopt -s lastpipe  #used for counters    CAUSES SEGMENTATION FAULT
export new_file_count=0
if [ ! -d ./users ]
then
	mkdir users
fi
while read line
do
	url=$line
	directory=$(echo "$line" |sed 's/http:\/\///'| sed 's/.imgur.com\///');
	if [ ! -d ./users/$directory ]
	then
		mkdir ./users/$directory
	fi
	cd users
	cd $directory
	wget -q $url -O -|\
	grep 'href=' |\
	grep 'com/a/' |\
	cut -d\" -f2 | \
	while read id;
	do dir=$(echo "$id" |sed 's/\/\/imgur.com\/a\///g');\
		mkdir -p $dir;
		cd $dir;
		echo "";
		echo "--------------";
		echo "Downloading http:$id -- from $directory" ;
		echo "--------------";
		wget -q "http:$id"
		deldir=$dir
		if cat $dir | grep -q 'i.imgur.com'
		then
			blog='/layout/blog'
			id2=$id$blog
			wget -q "http:$id2"
			echo "Downloading http:$id2 album"
			blog='blog'
			if [ -f $blog ]; then
				cat $blog | grep  'i.imgur.com'| grep -v 'cdnUrl'|\
				cut -d\" -f2 |grep '.com'| grep -v 'api.imgur'|\
				sed 's/\?[0-9]//g'|\
				while read id2;
				do
					id3=$(echo "$id2" |sed 's/\/\/i.imgur.com\///g')
					if [ -f $id3 ]; then
						echo "$id3 exists"
					else
						echo "Downloading...   http:$id2";
						wget -q -c "http:$id2";
					fi
				done;
			fi
		fi
		rm -f $dir
		rm -f blog
		rm -f index.html
		cd ..;
	done
	cd ../../
done < albums


