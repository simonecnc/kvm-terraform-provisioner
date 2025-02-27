
# kvm-terraform-provisioner
Automated deployment of Ubuntu virtual machines using Terraform on KVM. This project provides an infrastructure-as-code approach for managing VMs efficiently on a Linux environment.

## Automated Deployment of Ubuntu Servers with Terraform on KVM

### Prerequisites

1. Required packages to be installed on your Linux host:

   - Terraform
   - Python 3.13.2 (other versions are likely compatible as well)
   - Make
   - sshpass
   - KVM

2. Folder and file setup:

   - Download the image file from: [Ubuntu Cloud Images](https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img)
   - Place the downloaded image file in the following path: `~/iso/base/focal-server-cloudimg-amd64.img`

### Usage

1. Define the virtual machine parameters in the `data/vm_list.csv` file.

2. The default network used by KVM is `192.168.122.0/24`.

3. Execute the deployment script:

   ```sh
   python3 ./bin/deploy.py
   ```

   All configurations will be stored within the `VMs` directory.

4. To delete a virtual machine using Terraform, navigate to the respective VM directory (e.g., `/VMs/vm-1`) and run:

   ```sh
   make destroy
   make delete
   ```

>>>>>>> 518161f (First upload)
