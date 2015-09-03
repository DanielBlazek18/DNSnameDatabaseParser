#!/bin/bash
fileName=$1
regexEntity="[a-zA-Z]*-[a-zA-Z0-9]*-[0-9]*e[0-9]\{3\}"

if [ "$fileName" = "" ]; then
        echo "You not specify the filename!"
elif [ "$fileName" != "" ]; then
	read -p "Press [Enter] key to open file..."
    vi $fileName
    cat $fileName | awk {'print $1'} > temporaryFile
    echo "I am working..."
        
	while read line; do
		if [ -e "temporaryFile2" ]; then rm temporaryFile2; fi
		if [ -e "existornot" ]; then rm existornot; fi
		site $line | grep $regexEntity | awk {'print $1, $2, $3'} >> temporaryFile2
		grep $regexEntity temporaryFile2 >> existornot
		[ -s existornot ] && echo $line "is valid" || echo $line "does not exist!" 
			
		while read line2; do
			if [[ $line2 == *"Router"* && $line2 == *W[0-1]*[a-zA-Z]*[0-9]* || $line2 == *"Switch"* && $line2 == *W[0-1]*[a-zA-Z]*[0-9]* ]]; then
				echo $line2 >> validE
				if [ -e "invalidE" ]; then rm invalidE; fi
				break;
			else 
				echo $line2 >> invalidE 
			fi
		done < temporaryFile2
	
	if [ -e "invalidE" ]; then
		head -1 invalidE >> invalidE2
		rm  invalidE
	fi	
	done < temporaryFile

	awk '{ printf "%-37s %-10s %s\n", $1, $2, $3 }' validE >> validEntitiesNewFormat
	awk '{ printf "%-37s %-10s %s\n", $1, $2, $3 }' invalidE2 >> invalidEntitiesNewFormat

	#Final output
	echo ""
	echo "*** routers or switches ***"
	cat validEntitiesNewFormat
	echo ""
	echo "*** other entities ***"
	cat invalidEntitiesNewFormat
	rm $fileName
		
	if [ -e "temporaryFile" ]; then rm temporaryFile; fi
	if [ -e "temporaryFile2" ]; then rm temporaryFile2; fi
	if [ -e "validEntitiesNewFormat" ]; then rm validEntitiesNewFormat; fi
	if [ -e "invalidEntitiesNewFormat" ]; then rm invalidEntitiesNewFormat; fi
	if [ -e "validE" ]; then rm validE; fi
	if [ -e "invalidE2" ]; then rm invalidE2; fi
	if [ -e "existornot" ]; then rm existornot; fi
fi
