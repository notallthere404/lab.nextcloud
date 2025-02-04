import os
import json
import subprocess
from textwrap import dedent
from dotenv import load_dotenv, set_key

## This script reads the output IP addresses after terraform apply ##
## writing the values to ansible/inventory.ini and .env            ##


# Loads ssh key path from env
def load_environment():
    """Load environment variables from .env file"""
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
        'lb': tf_output['lb_fip']['value'],
        'web1': tf_output['web_server_1_ip']['value'],
        'web2': tf_output['web_server_2_ip']['value'],
        'db': tf_output['db_ip']['value']
    }
    return ips

# Writes the ssh key path and IP addresses into ansible/inventory.ini
def write_inventory(ssh_key_path, ips):
    inventory_path = os.path.expanduser('~/lab.nextcloud/ansible/inventory.ini')
    
    inventory_content = dedent(f"""\
        [bastion]
        bs ansible_host={ips['bastion']} ansible_user=ubuntu

        [load_balancer]
        lb ansible_host={ips['lb']} ansible_user=ubuntu ansible_ssh_port=22

        [database]
        db ansible_host={ips['db']} ansible_user=ubuntu ansible_ssh_port=22

        [webservers]
        web-1 ansible_host={ips['web1']} ansible_user=ubuntu ansible_ssh_port=22
        web-2 ansible_host={ips['web2']} ansible_user=ubuntu ansible_ssh_port=22

        [all:vars]
        ansible_ssh_private_key_file={ssh_key_path}
    """)

    os.makedirs(os.path.dirname(inventory_path), exist_ok=True)
    
    with open(inventory_path, 'w') as f:
        f.write(inventory_content)
    print(f"Generated inventory.ini successfully at {inventory_path}")


# Writes IP address to DATABASE_HOST in .env
def write_to_env(ips):
    env_path = os.path.expanduser('~/lab.nextcloud/.env')

    set_key(dotenv_path=env_path, key_to_set="DATABASE_HOST", value_to_set=(ips['db']))
    print("Set database IP in dot env")

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
