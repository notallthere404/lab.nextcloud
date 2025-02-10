import os
import yaml
from dotenv import load_dotenv

# Creates dictionary for the ansible vars using .env variables
def generate_main_yaml():

    load_dotenv()

    vars = {
            'db_user': os.getenv('DATABASE_USERNAME', 'nextcloud'),
            'db_name': os.getenv('DATABASE_NAME', 'nextcloud'),
            'db_password': os.getenv('DATABASE_PASSWORD', 'nextcloud'),
            'host_ip': os.getenv('HOST_IP', ''),
            'nc_user': os.getenv('NEXTCLOUD_ADMIN', 'nextcloudadmin'),
            'nc_password': os.getenv('NEXTCLOUD_PASSWORD', 'adminpassword'),
        }
    
    # Define the paths to the vars in ansible
    app_path = os.path.expanduser('~/lab.nextcloud/ansible/playbooks/roles/nextcloud/vars/main.yml')
  
    # Write to paths using vars as content
    with open(app_path, 'w') as p:
        yaml.dump(vars, p, default_flow_style=False)

    return vars


def main():

    clouds_config = generate_main_yaml()
    
    # Verify in output
    print(yaml.dump(clouds_config, default_flow_style=False))

if __name__ == "__main__":
    main()