#!/bin/bash
if [ "$1" = 'help' ]
then
	echo "Example:"
	echo "./service2resource.sh src/main/java/ com.fantong.chifaner.system.controller com.fantong.chifaner.system.service.PmsCustomerService"
	exit 0
fi

b_dir=$1
c_pname=$2
s_fname=$3
s_name=`echo "$s_fname" | sed 's/^[a-zA-Z.]*\.\(\w\+\)$/\1/g'`
c_name=${s_name/Service/Resource}
c_file=${b_dir}${c_pname//./\/}/${c_name}.java
echo $c_file
touch $c_file
echo "package ${c_pname};" > $c_file
echo "" >> $c_file
echo "import java.util.*;" >> $c_file
echo "import javax.servlet.http.*;" >> $c_file
echo "" >> $c_file
echo "import org.springframework.beans.factory.annotation.Autowired;" >> $c_file
echo "import org.springframework.stereotype.Controller;" >> $c_file
echo "import org.springframework.web.bind.annotation.*;" >> $c_file
echo "" >> $c_file
echo "import ${s_fname};" >> $c_file
echo "" >> $c_file
echo "" >> $c_file
echo "@Controller" >> $c_file
req_mapping=${c_name/Resource/}
# to lowercase
echo "@RequestMapping(\"/${req_mapping,,}\")" >> $c_file 
echo "public class ${c_name} {" >> $c_file
echo "" >> $c_file
echo -e "\t@Autowired" >> $c_file
param_name=`echo "$s_name" | sed 's/^[A-Z]/\L/'`
echo -e "\tprivate ${s_name} ${param_name};" >> $c_file
echo "" >> $c_file
echo -e "\t@PostMapping(\"/save\")" >> $c_file
echo -e "\t@ResponseBody" >> $c_file
echo -e "\tpublic String save(){" >> $c_file
echo -e "\t\t return null;" >> $c_file
echo -e "\t}" >> $c_file
echo "" >> $c_file
echo -e "\t@PostMapping(\"/update\")" >> $c_file
echo -e "\t@ResponseBody" >> $c_file
echo -e "\tpublic String update(){" >> $c_file
echo -e "\t\treturn null;" >> $c_file
echo -e "\t}" >> $c_file
echo "" >> $c_file
echo -e "\t@GetMapping(\"/list\")" >> $c_file
echo -e "\t@ResponseBody" >> $c_file
echo -e "\tpublic String list(){" >> $c_file
echo -e "\t\treturn null;" >> $c_file
echo -e "\t}" >> $c_file
echo "" >> $c_file
echo -e "\t@PostMapping(\"/delete\")" >> $c_file
echo -e "\t@ResponseBody" >> $c_file
echo -e "\tpublic String delete(){" >> $c_file
echo -e "\t\treturn null;" >> $c_file
echo -e "\t}" >> $c_file
echo "" >> $c_file
echo "}" >> $c_file




