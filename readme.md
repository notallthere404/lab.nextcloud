Terraform

1. Replace clouds.yaml(Can be downloaded from openstack horizon)
2. Replace ...openrc.sh(Can be downloaded from openstack horizon)
3. Replace variables.tf values
4. terraform init => terraform plan => terraform apply

Ansible

1. Add IP address & ssh key path to inventory.ini
2. Replace IP address & ssh key in ansible.cfg
3. 3. Add database IP to /playbooks/roles/postgres/vars/main.yml
4. Add database IP to /playbooks/roles/php/vars/main.yml
5. Replace domains and trusted IP in /playbooks/roles/php/templates/config.php.j2
6. Replace vars and web server IP addresses in ansible/playbooks/certify_load_balancer.yml
