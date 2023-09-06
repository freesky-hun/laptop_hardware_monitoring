#!/bin/bash
#Tested on: Acer Nitro 5 AN515-45 (pop-os 6.4.6-76060406-generic)

file_name="hardware_monitoring.log"
max_size_mb=10


if ! command -v sensors &> /dev/null
then
    echo "Error: sensors is not installed on the system."
    exit 1
fi

if ! command -v nvidia-smi &> /dev/null
then
    echo "Error: nvidia-smi is not installed on the system."
    exit 1
fi

if ! command -v free &> /dev/null
then
    echo "Error: free is not installed on the system."
    exit 1
fi


if [ ! -e "$file_name" ]; then
    touch /var/log/$file_name
fi


while true
do

t=$(date +'%Y:%m:%d %H:%M:%S')
cpu_temp=$(sensors | grep -oP 'temp1:\s+\+\K\d+\.\d+°C')
AMD_GPU_temp=$(sensors | grep -oP 'edge:\s+\+\K\d+\.\d+°C')
AMD_GPU_power=$(sensors | grep 'PPT:' | awk '{print $2}')
NV_GPU_temp=$(nvidia-smi | grep "Default" | awk '{print $3}')
NV_GPU_load=$(nvidia-smi | grep "Default" | awk '{print $13}')
NV_GPU_mem=$(nvidia-smi | grep "Default" | awk '{print $9}')
NV_GPU_power=$(nvidia-smi | grep "Default" | awk '{print $5}')
MEM=$(free -h | grep "Mem:" | awk '{print $3"/"$2}')

file_size=$(du -m /var/log/$file_name | cut -f1)

if [ "$file_size" -ge "$max_size_mb" ]; then
    echo "$t ==> CPU temp: $cpu_temp | AMD GPU temp: $AMD_GPU_temp | AMD GPU power: $AMD_GPU_power W | NV GPU temp: $NV_GPU_temp | NV GPU load: $NV_GPU_load | NV GPU mem: $NV_GPU_mem | NV GPU power: $NV_GPU_power | MEM: $MEM" > /var/log/$file_name
else
    echo "$t ==> CPU temp: $cpu_temp | AMD GPU temp: $AMD_GPU_temp | AMD GPU power: $AMD_GPU_power W | NV GPU temp: $NV_GPU_temp | NV GPU load: $NV_GPU_load | NV GPU mem: $NV_GPU_mem | NV GPU power: $NV_GPU_power | MEM: $MEM" >> /var/log/$file_name
fi

sleep 5

done