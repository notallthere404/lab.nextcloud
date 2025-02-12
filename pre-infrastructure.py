import os
import yaml
from dotenv import load_dotenv

## This script reads the .env file and writes the variables to files ##
## terraform main.tf, clouds.yaml, local playbook variables          ##

# Defines current working directory
project_path = os.getcwd()

# Loads .env variables
load_dotenv()

# Write ssh key path and VPN to local playbook
def set_local_vars():
    local_vars = {
        'ssh_path': os.getenv('SSH_KEY_PATH'),
        'vpn_name': os.getenv('VPN_CONF')
    }

    local_vars_path = os.path.join(project_path, 'ansible/playbooks/roles/manual/vars/main.yml')



    with open(local_vars_path, 'w') as f:
        yaml.dump(local_vars, f, default_flow_style=False)

    return print("---Local vars---\n", yaml.dump(local_vars, default_flow_style=False), "\n")

# Write ssh key path to main.tf
def set_terraform_vars():
    terraform_vars = (os.getenv('SSH_KEY_PATH') + '.pub')

    tf_path = os.path.join(project_path, 'terraform/main.tf')

    with open(tf_path, 'r') as file:
        lines = file.readlines()

    with open(tf_path, 'w') as file:
        for line in lines:
            if line.strip().startswith('public_key ='):
                file.write(f'  public_key = file("{terraform_vars}")\n')
            else:
                file.write(line)

    return print("---Terraform vars---\n", terraform_vars, "\n")

# Write Openstack variables to clouds.yaml
def set_clouds_yaml():
    clouds_vars = {
        'clouds': {
            'openstack': {  
                'auth': {
                    'auth_url': os.getenv('OS_AUTH_URL', 'https://lab.dsnw.dev:5000'),
                    'username': os.getenv('OS_USERNAME'),
                    'password': os.getenv('OS_PASSWORD'),
                    'project_id': os.getenv('OS_PROJECT_ID'),
                    'project_name': os.getenv('OS_PROJECT_NAME'),
                    'user_domain_name': os.getenv('OS_USER_DOMAIN_NAME', 'Default'),
                },
                'region_name': os.getenv('OS_REGION_NAME', 'RegionOne'),
                'interface': os.getenv('OS_INTERFACE', 'public'),
                'identity_api_version': os.getenv('OS_IDENTITY_API_VERSION', '3')
            }
        }
    }

    clouds_path = os.path.join(project_path, 'terraform/clouds.yaml')
    
    with open(clouds_path, 'w') as f:
        yaml.dump(clouds_vars, f, default_flow_style=False)
    
    #os.chmod(clouds_yaml_path, 0o600)

    return print("---Clouds.yaml---\n", yaml.dump(clouds_vars, default_flow_style=False))
    

def main():
    set_local_vars()
    set_terraform_vars()
    set_clouds_yaml()
    

if __name__ == "__main__":
    main()