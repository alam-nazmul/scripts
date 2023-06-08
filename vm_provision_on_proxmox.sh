#!/bin/bash

# Define variables
read -p "Enter the template ID: " source_temp_id
read -p "Enter an instance number: " instance_id
read -p "Enter the instance name: " new_vm_name
read -p "Enter the clone format: " instance_format
read -p "Enter the storage location: " storage_location
read -p "Enter the number of cores: " cores
read -p "Enter the number of sockets: " sockets
read -p "Enter the RAM size (in Kb): " ram
read -p "Enter the statis IP: " ip
read -p "Enter the subnet: " subnet
read -p "Enter the gateway: " gateway
read -p "Enter the disk size (GB): " disk_size


# Execute command
qm clone $source_temp_id $instance_id --name $new_vm_name --full --format $instance_format --storage $storage_location
qm set $instance_id --core $cores --memory $ram --sockets $sockets
qm set $instance_id --ipconfig0 ip=${ip}/${subnet},gw=$gateway
qm resize $instance_id scsi0 ${disk_size}G
