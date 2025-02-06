### Changelog 06/02/2025

1. Removed Ansible playbook roles php, postgres
2. Merged Ansible playbook roles ssh & vpn into local
3. Removed Ansible playbooks certify_loadbalancer.yml, setup_database.yml
4. Update inventory.ini
5. Removed vm_lb.tf, vm_db.tf
6. Removed web-server-2 from vm_web.tf
7. Added floating IP to webserver
8. Updated vars/inventory-generator.py
9. Added venv with pyyaml and dotenv
10. Updated Readme

Preparation:

1. Run playbook setup_local.yml to connect to wireguard and generate ssh key(optional)
2. Select automatic method or manual method
3. Automatic:
   a. Fill in .env.template and remove .template from name
   b. Activate virtual environment with "source venv/bin/activate"
   c. Run command "python clouds-generator.py" to create clouds.yaml
4. Manual:
   a. Login to openstack horizon
   b. Fetch clouds.yaml and openrc.sh
   c. Run source /path/to/openrc.sh
   d. Enter password
5. Set ssh key path in variables.tf and main.tf
6. terraform init => terraform plan => terraform apply

7. Automatic:
   a. Run command "python inventory-generator.py" and "python vars-generator.py"
8. Manual:
   a. Get IP-addresses from output
   b. Input IP-addresses and ssh key path to inventory.ini
   c. Input IP-addresses and ssh key path to ansible.cfg
   d. Enter database info into ansible/playbooks/roles/app-stack/templates/docker-compose.yml.j2
