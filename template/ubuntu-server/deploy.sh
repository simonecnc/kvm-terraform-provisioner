#!/bin/bash


make delete-keys

make create-keypair


make resize-disk

make init

make apply

make remove-disk

# Continue to repeat until make ssh-copy-id succeeds
until make ssh-copy-id; do
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

