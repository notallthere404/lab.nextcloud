Terraform

1. Remove .template from .env.template file and enter credentials
   a. Variables in use are:
   b. Cloud Provider Credentials
   c. ssh key path
   d. Ansible vars
2. Create python virtual env in lab.nextcloud and activate it
3. pip install pyyaml and python-dotenv
4. Run clouds-generator.py
5. Replace variables.tf values
6. terraform init => terraform plan => terraform apply

Ansible

1. Run inventory-generator.py after terraform apply to create inventory.ini and write to .env
2. Run vars-generator.py to write to vars
3. Create lab-creds.ini using info on darksnowlab wiki
4. Replace vars and web server IP addresses in ansible/playbooks/certify_load_balancer.yml
