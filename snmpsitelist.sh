#!/bin/bash
fileName=$1
regexEntity="[a-zA-Z]*-[a-zA-Z0-9]*-[0-9]*e[0-9]\{3\}"

touch temporaryFile temporaryFile2 validEntities invalidEntities
touch validEntitiesNewFormat invalidEntitiesNewFormat
rm temporaryFile temporaryFile2 validEntities invalidEntities
rm validEntitiesNewFormat invalidEntitiesNewFormat

if [ "$fileName" = "" ]; then
        echo "You not specify the filename!"
elif [ "$fileName" != "" ]; then
	read -p "Press [Enter] key to open file..."
	vi $fileName
	cat $fileName | awk {'print $1'} > temporaryFile 
	echo "I am working..."
	echo ""
	while read line 
	do 
		site $line | grep $regexEntity | awk {'print $1, $2, $3;exit;'} >> temporaryFile2
	done < temporaryFile
			
	#make two files, one will contains valid entity 
	#second will contains invalid entity
	while read line 
	do 
		typeOfDevice=$(echo $line | awk {'print $3'})
		if [ "$typeOfDevice" == "Router" ]; then
			echo $line >> validEntities
		elif [ "$typeOfDevice" == "Switch" ]; then
			echo $line >> validEntities
		else
			echo $line >> invalidEntities
		fi
	done < temporaryFile2
	
	awk '{ printf "%-30s %-10s %s\n", $1, $2, $3 }' validEntities >> validEntitiesNewFormat
	awk '{ printf "%-30s %-10s %s\n", $1, $2, $3 }' invalidEntities >> invalidEntitiesNewFormat
	
	#Final output
	echo "*** routers or switches ***"
	cat validEntitiesNewFormat
	echo ""
	echo "*** other entities ***"
	cat invalidEntitiesNewFormat
	rm $fileName
	rm temporaryFile temporaryFile2 validEntities invalidEntities
	rm validEntitiesNewFormat invalidEntitiesNewFormat
fi
