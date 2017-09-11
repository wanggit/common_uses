#!/bin/bash
if [ "$1" = 'help' ]
then
	echo "Example:"
	echo "./service2impl.sh src/main/java/ com.fantong.chifaner.system.service PmsCustomerService"
	exit 0
fi
base_dir=$1
p_name=$2
i_name=$3
i_file=${base_dir}${p_name//./\/}/${i_name}.java
impl=${base_dir}${p_name//./\/}/impl/${i_name}Impl.java
echo $i_file
cp -v $i_file $impl

sed -i 's/service/service.impl/' $impl
sed -i 's/interface/class/' $impl
sed -i "s/${i_name}/${i_name}Impl implements ${i_name}/" $impl
sed -i 's/);/){}/g' $impl

sed -i "/import java.util.List/a import ${p_name}.${i_name};" $impl
mp_name=${p_name/service/mapper}
mp_file=${i_name/Service/Mapper}
sed -i "/import java.util.List/a import ${mp_name}.${mp_file};" $impl

sed -i "/import java.util.List/a import org.springframework.beans.factory.annotation.Autowired;" $impl
sed -i "/import java.util.List/a import org.springframework.stereotype.Service;" $impl
sed -i "/import java.util.List/a import org.springframework.transaction.annotation.Transactional;" $impl

sed -i "s/public class/@Service \npublic class/" $impl
sed -i "s/public class/@Transactional(rollbackFor = Exception.class) \npublic class/" $impl

param_name=$(echo "$mp_file" | sed 's,^[A-Z],\L&,g')
sed -i "/public class ${i_name}Impl implements ${i_name} {/a @Autowired\n\tprivate ${mp_file} ${param_name};\n" $impl
sed -i 's/@Autowired/\n\t@Autowired/g' $impl

sed -i 's/^\s*\b\(int\)/\tpublic \1/g' $impl
sed -i 's/^\s*\(List<\)/\tpublic \1/g' $impl
sed -i "s/^\s*\(${mp_file/Mapper/}\)/\tpublic \1/g" $impl

sed -i "s/^\(.*countByExample(\w\+\s\+\(\w\+\)).*\){}$/\1{\n\t\treturn ${param_name}.countByExample(\2);\n\t}/" $impl
sed -i "s/^\(.*deleteByExample(\w\+\s\+\(\w\+\)).*\){}$/\1{\n\t\treturn ${param_name}.deleteByExample(\2);\n\t}/" $impl
sed -i "s/^\(.*deleteByPrimaryKey(\w\+\s\+\(\w\+\)).*\){}$/\1{\n\t\treturn ${param_name}.deleteByPrimaryKey(\2);\n\t}/" $impl
sed -i "s/^\(.*insert(\w\+\s\+\(\w\+\)).*\){}$/\1{\n\t\treturn ${param_name}.insert(\2);\n\t}/" $impl
sed -i "s/^\(.*insertSelective(\w\+\s\+\(\w\+\)).*\){}$/\1{\n\t\treturn ${param_name}.insertSelective(\2);\n\t}/" $impl
sed -i "s/^\(.*selectByExample(\w\+\s\+\(\w\+\)).*\){}$/\1{\n\t\treturn ${param_name}.selectByExample(\2);\n\t}/" $impl
sed -i "s/^\(.*selectByPrimaryKey(\w\+\s\+\(\w\+\)).*\){}$/\1{\n\t\treturn ${param_name}.selectByPrimaryKey(\2);\n\t}/" $impl
sed -i "s/^\(.*updateByPrimaryKeySelective(\w\+\s\+\(\w\+\)).*\){}$/\1{\n\t\treturn ${param_name}.updateByPrimaryKeySelective(\2);\n\t}/" $impl
sed -i "s/^\(.*updateByPrimaryKey(\w\+\s\+\(\w\+\)).*\){}$/\1{\n\t\treturn ${param_name}.updateByPrimaryKey(\2);\n\t}/" $impl
sed -i "s/^\(.*updateByExampleSelective(\w\+\s\+\(\w\+\),\s\+\w\+\s\+\(\w\+\)).*\){}$/\1{\n\t\treturn ${param_name}.updateByExampleSelective(\2, \3);\n\t}/" $impl
sed -i "s/^\(.*updateByExample(\w\+\s\+\(\w\+\),\s\+\w\+\s\+\(\w\+\)).*\){}$/\1{\n\t\treturn ${param_name}.updateByExample(\2, \3);\n\t}/" $impl

#sed -i 's/int/public int/g' $impl

