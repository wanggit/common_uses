#!/bin/bash
if [ "$1" = 'help' ]
then
	echo "Example:"
	echo "./autogen.sh src/main/java/com/fantong/chifaner/system/mapper/ src/main/java/com/fantong/chifaner/system/service src/main/java/ com.fantong.chifaner.system.controller"
	exit 0
fi
mapper_dir=$1
service_dir=$2
b_dir=$3
controller_dir=$4

mkdir -p ${mapper_dir}
mkdir -p ${service_dir}/impl
mkdir -p ${b_dir}${controller_dir//./\/}

for mp in `ls ${mapper_dir}`
do
	if [[ "$mp" =~ ".java" ]]
	then
		echo "${mapper_dir}${mp}"
		./mapper2service.sh ${mapper_dir}${mp} ${service_dir}/${mp/Mapper/Service} ${service_dir//$b_dir/}
		s_pname=${service_dir/"${b_dir}"/}
		s_pname=${s_pname//\//.}
		len=${#s_pname}
		len=`expr $len - 1`
		s_fname=${mp/Mapper.java/Service}
		mapper_full_name=${mapper_dir}${mp}
		mfn_without_dbir=${mapper_full_name//$b_dir/}
		./service2impl.sh ${b_dir} $s_pname $s_fname ${mfn_without_dbir//\//.}
		./service2resource.sh ${b_dir} ${controller_dir} ${s_pname}.${s_fname}
		
	fi
	
done

