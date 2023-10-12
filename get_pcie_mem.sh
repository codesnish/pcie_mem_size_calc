#!/bin/bash

# Check the number of arguments
if [ "$#" -ne 1 ]; then
	echo "Error: Invalid number of arguments. Usage: $0 <pcie_device_id>"
	exit 1
fi

# Read BAR register of the PCI device with specified device ID
device_id="$1"
BAR0_val=$(setpci -s "$device_id" BASE_ADDRESS_0)

echo "Initial BAR0 value: $BAR0_val"

# Calculate the number of bytes in the BAR0
num_bytes=$(( (${#BAR0_val}) / 2 ))

# Loop to extract individual bytes and store them in separate variables
for ((i = 0; i < num_bytes; i++)); do
	# Calculate start and end index of the byte in BAR0 string
	start=$((i * 2))
	end=$((start + 2))

	# Extract the byte from BAR0 string
	byte="${BAR0_val:$start:2}"

	# Store the byte in a separate variable
	var_name="etyb_$((i))"
	declare "$var_name"="$byte"
done

# # Print etyb_i
# for ((i = 0; i < num_bytes; i++)); do
# 	etyb_var="etyb_$i"
# 	echo "$etyb_var: ${!etyb_var}"
# done

# Loop to reverse the order of byte_variables
for ((i = 0; i < num_bytes; i++)); do
	etyb_var="etyb_$i"
	byte_var="byte_$((num_bytes - i - 1))"
	eval "$byte_var=\"\$$etyb_var\""
done

# # Print byte_i
# for ((i = 0; i < num_bytes; i++)); do
# 	byte_var="byte_$i"
# 	echo "$byte_var: ${!byte_var}"
# done

# Set BAR register to all 1s
setpci -s "$device_id" 10.b=ff,ff,ff,ff

# Read BAR register again
new_BAR0_val=$(setpci -s "$device_id" BASE_ADDRESS_0)

echo "Modified BAR0 value: $new_BAR0_val"

# Compile the C program & pass the new_BAR0_val value to it
gcc -o calc_mem calc_mem.c
output=$(./calc_mem "$new_BAR0_val")
rm calc_mem
echo $output

# Loop to set back the original values back to each register
for ((j = 0; j < num_bytes; j++)); do
	BAR0_addr=$((j+10))
	eval "byte_var=\$byte_$j"
	setpci -s "$device_id" "$BAR0_addr.b=$byte_var"
done 

echo "BAR0 restored with value: $(setpci -s "$device_id" BASE_ADDRESS_0)"
