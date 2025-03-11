#!/bin/bash


# Check parameters
if [ "$#" -ne 6 ]; then
    echo "Uso: $0 <hostname> <ip> <username> <password> <disk-size> <memorymb>"
    exit 1
fi

# Variables definition
HOSTNAME=$1
IP=$2
USERNAME=$3
PASSWORD=$4
DISK_SIZE=$5
RAM=$6

# File path
BASE_PATH="../template/ubuntu-server"
VM_PATH="../VMs"
HOSTNAME_PATH="$VM_PATH/$HOSTNAME"
TFVARS_FILE="$VM_PATH/$HOSTNAME/$HOSTNAME.tfvars"
MAKEFILE="$VM_PATH/$HOSTNAME/Makefile"

# Input confirmation message
echo "-------------------------"
echo "Configuring the VM with the following parameters:"
echo "Hostname: $HOSTNAME"
echo "IP: $IP"
echo "Username: $USERNAME"
echo "Password: $PASSWORD"
echo "Disk size: $DISK_SIZE"
echo "Ram: $RAM"
echo "-------------------------"

# Creating the directory and copying the files
echo "#### Copy file from $BASE_PATH to $VM_PATH/$HOSTNAME ####"
cp -r "$BASE_PATH" "$VM_PATH" && mv "$VM_PATH/ubuntu-server" "$VM_PATH/$HOSTNAME"

# Rename the tfvars file
mv "$VM_PATH/$HOSTNAME/ubuntu-server.tfvars" "$TFVARS_FILE"

echo "### Editing the $TFVARS_FILE ###"
# Editing the tfvars file with the provided parameters
sed -i "s/^hostname=\"\"/hostname=\"$HOSTNAME\"/" "$TFVARS_FILE"
sed -i "s/^ip=\"\"/ip=\"$IP\"/" "$TFVARS_FILE"
sed -i "s/^username=\"\"/username=\"$USERNAME\"/" "$TFVARS_FILE"
sed -i "s/^password=\"\"/password=\"$PASSWORD\"/" "$TFVARS_FILE"
sed -i "s/^disk-size=/disk-size=$DISK_SIZE/" "$TFVARS_FILE"
sed -i "s/^memoryMB=/memoryMB=$RAM/" "$TFVARS_FILE"

echo "Contents of $TFVARS_FILE after modification:"
cat "$TFVARS_FILE"

# Update makefile
echo "### Updating the Makefile ###"
sed -i "s/^HOSTNAME := .*/HOSTNAME := $HOSTNAME/" "$MAKEFILE"
sed -i "s/^IP := .*/IP := $IP/" "$MAKEFILE"
sed -i "s/^USERNAME := .*/USERNAME := $USERNAME/" "$MAKEFILE"
sed -i "s/^PASSWORD := .*/PASSWORD := $PASSWORD/" "$MAKEFILE"
sed -i "s/^DISK-SIZE := .*/DISK-SIZE := $DISK_SIZE/" "$MAKEFILE"
#sed -i "s/^MEMORYMB := .*/MEMORYMB := $RAM/" "$MAKEFILE"

echo "Setup completed successfully!"

make -C $HOSTNAME_PATH create-keypair

make -C $HOSTNAME_PATH delete-keys

make -C $HOSTNAME_PATH create-keypair

make -C $HOSTNAME_PATH resize-disk

make -C $HOSTNAME_PATH init

make -C $HOSTNAME_PATH apply

make -C $HOSTNAME_PATH remove-disk

# Continue to repeat until make ssh-copy-id succeeds
until make -C $HOSTNAME_PATH ssh-copy-id; do
    echo "Attempt failed, retrying in 5 seconds..."
    sleep 5
done

#Connection
#read -p "Do you want to connect to the server now? (y/n): " choice

#if [[ $choice == "y" || $choice == "Y" ]]; then
#    make connect
#else
#    echo "Operation canceled. 'make connect' will not be executed."
#fi

echo "-------------------------"

sleep 2
