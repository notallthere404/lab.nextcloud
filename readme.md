## 11/02/2025

Automatic config:

Instance Deployment

1. Set .env variables(Remove .template from file name)
2. [Directory: ansible/] cmd `ansible-playbook playbooks/setup_local.yml` (`--ask-become-pass` flag might be needed if permission is denied)
3. [Directory: ansible/] cmd `ansible-playbook playbooks/setup_manual.yml`
4. [Directory: terraform/] cmd `terraform init` => `terraform plan` => `terraform apply`

Nextcloud Deployment

1. [Directory: ansible/] cmd `ansible-playbook playbooks/setup_ansible.yml`
2. [Directory: ansible/] cmd `ansible-playbook playbooks/setup_webserver.yml`

Changelog:

1. Cleaner python code
2. Improved setup local playbook

## 10/02/2025

Prerequisites

- lab.nextcloud files
- Ansible
- Terraform
- Wireguard | Get vpn conf for wireguard and place in /etc/wireguard/...
- ssh

Automatic

Cloud configuration & Instance Deployment

1. Rename .env.template to .env (location lab.nextcloud)
2. Set the variables in .env(Default values are optional to change)
   (HOST_IP is written automatically)
3. Activate virtual env "source venv/bin/activate"
4. Run "python pre-deployment.py"
5. Run "ansible-playbook ansible/playbooks/setup_local.yml"
6. (Optional) set key path in main.tf if not using default
7. cd into lab.nextcloud/terraform
8. Run "terraform init"
9. Run "terraform plan"
   10.Run "terraform apply"

Nextcloud Deployment

1. Run "python inventory-generator.py"
2. Run "python vars-generator.py"
3. cd into ansible
4. Run "ansible-playbook playbooks/setup_webserver.yml

Manual

Cloud configuration & Instance Deployment

1. Get vpn conf for wireguard and place in /etc/wireguard/...
2. Set variables in lab.nextcloud/ansible/playbooks/roles/local/vars/main.yml
   (Set a new ssh key path if you want or use the default)
3. cd into ansible/
4. run "ansible-playbook playbooks/setup_local.yml
   (ssh key is now generated and vpn is now connected to)
5. (Optional) Set ssh key path in terraform/main.tf if changed from default
6. Get clouds.yaml and openrc.sh script and place in lab.nextcloud/terraform
7. cd into lab.nextcloud/terraform
8. Run cmd "source ...openrc.sh" and enter password
9. Run "terraform init"
   10.Run "terraform plan"
   11.Run "terraform apply"
   12.Save IP addresses for later use if desired

Nextcloud Deployment

1. cd back to ansible
2. Change IP addresses in inventory.ini(use webserver_ip not fip)
3. Change IP address to bastion_fip in ansible.cfg
4. Change variables in lab.nextcloud/ansible/playbooks/roles/nextcloud/vars/main.yml
   a. host_ip => webserver_fip
   b. nextcloud credentials(Optional)
5. Run "ansible-playbook playbooks/setup_webserver.yml"
