import os
import json
import subprocess
from textwrap import dedent
from dotenv import load_dotenv, set_key

## This script reads the output IP addresses after terraform apply ##
## writing the values to ansible/inventory.ini and .env            ##


# Loads ssh key path from env
def load_environment():
    load_dotenv()
    return os.getenv('SSH_KEY_PATH')


# Intercepts stdout and reads addresses into "ips"
def get_terraform_output():
    """Get IP addresses directly from terraform output command"""
    result = subprocess.run(['terraform', 'output', '-json'], 
                            capture_output=True, text=True, check=True)
    
    tf_output = json.loads(result.stdout)
    
    ips = {
        'bastion': tf_output['bastion_fip']['value'],
        'web_fip': tf_output['webserver_fip']['value'],
        'web': tf_output['webserver_ip']['value'],
    }
    return ips

# Writes the ssh key path and IP addresses into ansible/inventory.ini
def write_inventory(ssh_key_path, ips):
    inventory_path = os.path.expanduser('~/lab.nextcloud/ansible/inventory.ini')
    config_path = os.path.expanduser('~/lab.nextcloud/ansible/ansible.cfg')
    
    inventory_content = dedent(f"""\
        [bastion]
        bs ansible_host={ips['bastion']} ansible_user=ubuntu

        [webserver]
        web ansible_host={ips['web']} ansible_user=ubuntu ansible_ssh_port=22

        [all:vars]
        ansible_ssh_private_key_file={ssh_key_path}
    """)

    config_content = dedent(f"""\
        [defaults]
        inventory = inventory.ini

        [ssh_connection]
        ssh_args = -o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q ubuntu@{ips['bastion']} -i {ssh_key_path}"
    """)

    os.makedirs(os.path.dirname(inventory_path), exist_ok=True)
    os.makedirs(os.path.dirname(config_path), exist_ok=True)
    
    with open(inventory_path, 'w') as p:
        p.write(inventory_content)
    print(f"Generated inventory.ini successfully at {inventory_path}")

    with open(config_path, 'w') as p:
        p.write(config_content)
    print(f"Generated ansible.cfg successfully at {config_path}")

def write_to_env(ips):
    env_path = os.path.expanduser('~/lab.nextcloud/.env')

    set_key(dotenv_path=env_path, key_to_set="HOST_IP", value_to_set=(ips['web_fip']))
    print("Set host IP in dot env")

def main():
    try:
        ssh_key_path = load_environment()
        if not ssh_key_path:
            raise ValueError("SSH_KEY_PATH not found in .env file")

        ips = get_terraform_output()
        
        write_inventory(ssh_key_path, ips)

        write_to_env(ips)
        
    except Exception as e:
        print(f"Error: {str(e)}")
        exit(1)

if __name__ == "__main__":
    main()
