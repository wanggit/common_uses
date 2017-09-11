#!/bin/bash
rm -rfv system.tar
sed -i 's/dev/prod/g' ./src/main/resources/application.properties
mvn clean
mvn install
cd target
tar -cf system.tar lib com.fantong.chifaner.system.jar
mv system.tar ..
cd ..
sed -i 's/prod/dev/g' ./src/main/resources/application.properties

expect system_192_168_2_5.exp

rm -fv system.tar
