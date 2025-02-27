
THISDIR := $(shell basename "$(CURDIR)")
PROJECT := $(THISDIR)

TERRAFORM := terraform
#dynamic var
HOSTNAME := ubuntu-server
OCTET_IP := 11
IP := 192.168.122.11
USERNAME := ubuntu
PASSWORD := password
DISK-SIZE := 30

# Target to create an SSH key pair
create-keypair:
	@echo "THISDIR=$(THISDIR)"
	yes y | ssh-keygen -t rsa -b 4096 -f id_rsa -C $(IP) -N "" -q

# Target to resize the disk image stored in ~/iso/base temporary copied in /tmp
resize-disk:
	cp ~/iso/base/focal-server-cloudimg-amd64.img /tmp/focal-server-cloudimg-amd64.img
	qemu-img resize /tmp/focal-server-cloudimg-amd64.img +$(DISK-SIZE)G

# Target to initialize Terraform
init:
	$(TERRAFORM) init

# Target to apply Terraform configurations
apply:
	$(TERRAFORM) apply -auto-approve -var-file=$(THISDIR).tfvars

# Target to remove the temporary disk image
remove-disk:
	rm /tmp/focal-server-cloudimg-amd64.img

# Target to delete SSH keys from the known hosts file
delete-keys:
	ssh-keygen -f ~/.ssh/known_hosts -R $(IP)

# Target to copy the SSH key to the remote server
ssh-copy-id:
	sshpass -p $(PASSWORD) ssh-copy-id -o StrictHostKeyChecking=no $(USERNAME)@$(IP)

# Target to connect to the remote server via SSH
connect:
	ssh $(USERNAME)@$(IP)


## recreate terraform resources
rebuild: destroy apply

destroy:
	$(TERRAFORM) destroy -auto-approve


## create public/private keypair for ssh



metadata:
	$(TERRAFORM) refresh && $(TERRAFORM) output

## validate syntax of cloud_init
validate-cloud-config:
	cloud-init devel schema --config-file=cloud_init.cfg


delete:
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup id_rsa id_rsa.pub


test:
	echo "ok"