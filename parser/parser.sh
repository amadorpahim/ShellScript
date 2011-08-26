#!/bin/bash

while read LINE 
do
	key=$(echo $LINE | sed 's/ = /=/g' | cut -d "=" -f 1)
	value=$(echo $LINE | sed 's/ = /=/g' | cut -d "=" -f 2)
	eval $key=\"${value}\"

done < $config_file
