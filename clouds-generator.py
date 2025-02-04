import os
import yaml
from dotenv import load_dotenv

# Creates dictionary for cloud.yaml using .env variables
def generate_clouds_yaml():

    load_dotenv()

    clouds_config = {
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

    # Define the path for terraform/clouds.yaml
    config_dir = os.path.expanduser('terraform')
    clouds_yaml_path = os.path.join(config_dir, 'clouds.yaml')

    # Dumps the yaml in defined path
    with open(clouds_yaml_path, 'w') as f:
        yaml.dump(clouds_config, f, default_flow_style=False)
    
    # Set permissions
    os.chmod(clouds_yaml_path, 0o600)
    
    return clouds_config

def main():
    # Generate clouds.yaml
    clouds_config = generate_clouds_yaml()
    
    # Verify config in output
    print(yaml.dump(clouds_config, default_flow_style=False))

if __name__ == "__main__":
    main()