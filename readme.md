## Prerequisites

- Ubuntu ([Installation guide](https://ubuntu.com/tutorials/install-ubuntu-desktop#1-overview))
- Ansible for Ubuntu ([Installation guide](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html))
- Terraform for Ubuntu/Debian ([Installation guide](https://developer.hashicorp.com/terraform/install))
- Wireguard ([Install Wireguard](https://www.wireguard.com/install/) and place your .conf file in /etc/wireguard/)
- Lab files (Clone or download this repository and place in /home)
- OpenStack clouds.yaml file (Download from your OpenStack account)
* * *

** **Choose one of the two installation options below: Automatic or Manual.** **
* * *
## Option 1: Automatic installation
Get up and running with (almost) zero effort by following these easy steps:

**Setup and Deployment**
1. Rename `.env.template` to `.env` 
2. Set the variables in `.env` according to the details in your cloud.yaml file, but leave `HOST_IP` empty as it will be auto-generated.
   - (Default values are optional to change.)
3. Navigate to the lab.nextcloud/ansible directory using `cd`
4. Run `ansible-playbook ansible/playbooks/setup_local.yml`  to create virtual environment and load dependencies
	 - (Use the `--ask-become-pass` flag if permission is denied.)
5. Run `ansible-playbook playbooks/setup_manual.yml` to check VPN connection and generate SSH key
6. Navigate to the lab.nextcloud/terraform directory using `cd`
7. Run `terraform init` to initialize Terraform
8. Run `terraform plan` to preview the changes
9.  Run `terraform apply` to deploy infrastructure on OpenStack
	
**Installing Nextcloud**

1. Navigate to the lab.nextcloud/ansible directory using `cd`
2. Run `ansible-playbook playbooks/setup_ansible.yml` to configure Ansible and inventory.ini
3. Run `ansible-playbook playbooks/setup_webserver.yml` to install Docker, PostgreSQL and Nextcloud on the web server
4. Use the output from the last task to enter and access Nextcloud from your web browser
* * *
## Option 2: Manual installation
Want more control? You got it. Here's the manual way to get started:

**Setup and Deployment**

1. Set variables in `lab.nextcloud/ansible/playbooks/roles/manual/vars/main.yml`
   - (Optional) Change the SSH key path or use the default

2. Navigate to the Ansible directory using `cd`

3. Run the local setup playbook using `ansible-playbook playbooks/setup_manual.yml`
	- Note: If you changed the SSH key path in step 1, update it in terraform/main.tf.
  
4. Place your `clouds.yaml` and `openrc.sh` file in lab.nextcloud/terraform

5. Navigate to the Terraform directory using `cd`

6. Load OpenStack credentials using `source openrc.sh`
	- Enter your password when prompted

7. Run `terraform init` to initialize Terraform
8. Run `terraform plan` to preview the changes
9.  Run `terraform apply` to deploy infrastructure on OpenStack

**Installing Nextcloud**

1. Return to the Ansible directory using `cd`
2. Update `inventory.ini` with the correct IP addresses (use `webserver_ip`, not `fip`).
3. Update `bastion_fip` in `ansible.cfg` with the correct IP address
4. Modify variables in `lab.nextcloud/ansible/playbooks/roles/nextcloud/vars/main.yml`:
	- Set `host_ip` to `webserver_fip`.
	- (Optional) Update Nextcloud credentials.
5. Run the Nextcloud setup playbook using `ansible-playbook playbooks/setup_webserver.yml`
6. Use the output from the last task to enter and access Nextcloud from your web browser
