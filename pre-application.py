import os
import yaml
import json
import subprocess
from textwrap import dedent
from dotenv import load_dotenv, set_key

## This script reads the output IP addresses after terraform apply ##
## writing the values to ansible.cfg/inventory.ini and to nextcloud##

# Defines current working directory
project_path = os.getcwd()

# Intercepts stdout, returning IP addresses as "ips"
def get_terraform_output():
    result = subprocess.run(['terraform', 'output', '-json'], 
                            capture_output=True, text=True, check=True)
    
    tf_output = json.loads(result.stdout)

    ips = {
        'bastion': tf_output['bastion_fip']['value'],
        'web_fip': tf_output['webserver_fip']['value'],
        'web_ip': tf_output['webserver_ip']['value'],
    }
    return ips

# Write web floating IP to HOST_IP var in .env
def set_env(ips):
    env_path = os.path.join(project_path, '.env')

    set_key(dotenv_path=env_path, key_to_set="HOST_IP", value_to_set=(ips['web_fip']))

    return print("Set host IP: ", (ips['web_fip']), "\n")


# Writes the IP addresses into ansible/inventory.ini
def set_inventory(ips):    
    inventory_content = dedent(f"""\
        [bastion]
        bs ansible_host={ips['bastion']} ansible_user=ubuntu

        [webserver]
        web ansible_host={ips['web_ip']} ansible_user=ubuntu ansible_ssh_port=22
    """)

    inventory_path = os.path.join(project_path, 'ansible/inventory.ini')

    with open(inventory_path, 'w') as p:
        p.write(inventory_content)

    return print("Generated inventory.ini\n")

# Writes the ssh key path and bastion floating IP address into ansible config
def set_config(ips):
    config_content = dedent(f"""\
        [defaults]
        inventory = inventory.ini

        [ssh_connection]
        ssh_args = -o ProxyCommand="ssh -W %h:%p ubuntu@{ips['bastion']}"
    """)

    config_path = os.path.join(project_path, 'ansible/ansible.cfg')
    
    with open(config_path, 'w') as p:
        p.write(config_content)

    return print(f"Generated ansible.cfg\n")

# Loads env and web floating and writes to nextcloud vars
def set_nextcloud_vars(ips):
    load_dotenv()

    nc_vars = {
            'db_user': os.getenv('DATABASE_USERNAME', 'nextcloud'),
            'db_name': os.getenv('DATABASE_NAME', 'nextcloud'),
            'db_password': os.getenv('DATABASE_PASSWORD', 'nextcloud'),
            'host_ip': {ips['web_fip']},
            'nc_user': os.getenv('NEXTCLOUD_ADMIN', 'nextcloudadmin'),
            'nc_password': os.getenv('NEXTCLOUD_PASSWORD', 'adminpassword'),
        }
    
    nc_vars_path = os.path.join(project_path, 'ansible/playbooks/roles/nextcloud/vars/main.yml')
  
    with open(nc_vars_path, 'w') as p:
        yaml.dump(nc_vars, p, default_flow_style=False)

    return print("---Nextcloud vars---\n", nc_vars)


def main():
    try:
        ips = get_terraform_output()
        
        set_env(ips)

        set_inventory(ips)

        set_config(ips)

        set_nextcloud_vars(ips)
        
    except Exception as e:
        print(f"Error: {str(e)}")
        exit(1)

if __name__ == "__main__":
    main()
