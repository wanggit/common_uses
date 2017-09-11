#!/bin/bash
if [ "$1" = 'help' ]
then
	echo "Example:"
	echo './mapper2service.sh src/main/java/com/fantong/chifaner/system/mapper/PmsTransferAccountMapper.java src/main/java/com/fantong/chifaner/system/service/PmsTransferAccountService.java'
	exit 0
fi
file=$1
tofile=$2
cp -v $file $tofile
sed -i 's/mapper/service/' $tofile
sed -i 's/Mapper/Service/' $tofile
sed -i 's/import org.apache.ibatis.annotations.Param;//' $tofile
sed -i 's/@Param("record") //g' $tofile 
sed -i 's/@Param("example")//g' $tofile
