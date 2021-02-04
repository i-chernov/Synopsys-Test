#!/bin/bash

if [[ $1 != *"_defconfig" ]]; then
    echo "Please provide a config file. (e.g. qemu_x86_64_defconfig)"
    exit -1
fi

echo -e "\n---- Selected configuration: $1 ----\n"
make $1 2> buildroot-build-error.log

echo -e "\n---- Start building ----\n"
make 2>> buildroot-build-error.log

echo -e "\n---- Run boot test in QEMU ----\n"
if [ -f output/images/start-qemu.sh ]; then
    (sleep 20; echo root; sleep 5; echo poweroff) | ./output/images/start-qemu.sh | tee output/images/qemu-boot-test.log
else
    echo "start-qemu.sh is not found"
fi

echo -e "\n---- Create Artifact ----\n"
ARTIFACT=${ARTIFACTS}/${1:0:-10}-$(date +%Y_%m_%d_%H_%M)
[ ! -d ${ARTIFACT} ] && mkdir -p ${ARTIFACT}

cp -v buildroot-build-error.log ${ARTIFACT}
cp -v output/images/* ${ARTIFACT}
for f in $(find output/build/ -name "*.dtb"); do 
    cp -v $f ${ARTIFACT}
done

echo -e "\n---- DONE ----"
