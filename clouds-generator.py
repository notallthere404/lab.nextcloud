#!/usr/bin/env python3
import os
import yaml

def generate_clouds_yaml():
    # Dictionary to map environment variables to clouds.yaml structure
    clouds_config = {
        'clouds': {
            'nc': {  # You can name this cloud whatever you want
                'auth': {
                    'auth_url': os.getenv('CLOUD_AUTH_URL'),
                    'password': os.getenv('CLOUD_PROVIDER_PASSWORD'),
                    'project_name': os.getenv('CLOUD_PROJECT_NAME'),
                    'project_id': os.getenv('CLOUD_PROJECT_ID'),
                    'user_domain_name': os.getenv('CLOUD_USER_DOMAIN_NAME', 'Default'),
                },
                'region_name': os.getenv('CLOUD_PROVIDER_REGION'),
                'interface': os.getenv('CLOUD_INTERFACE', 'public'),
                'identity_api_version': os.getenv('CLOUD_IDENTITY_API_VERSION', '3')
            }
        }
    }
    
    # Ensure the .config/openstack directory exists
    config_dir = os.path.expanduser('~/.config/openstack')
    os.makedirs(config_dir, exist_ok=True)
    
    # Write clouds.yaml
    clouds_yaml_path = os.path.join(config_dir, 'clouds.yaml')
    with open(clouds_yaml_path, 'w') as f:
        yaml.dump(clouds_config, f, default_flow_style=False)
    
    # Set secure permissions
    os.chmod(clouds_yaml_path, 0o600)
    
    print(f"clouds.yaml generated at {clouds_yaml_path}")
    return clouds_config

def load_env_file(env_file_path):
    """Load environment variables from a .env file"""
    with open(env_file_path, 'r') as f:
        for line in f:
            # Skip comments and empty lines
            line = line.strip()
            if line and not line.startswith('#'):
                # Split on first '=' 
                key, value = line.split('=', 1)
                # Remove quotes if present
                value = value.strip('\'"')
                os.environ[key.strip()] = value

def main():
    # Load .env file
    load_env_file('.env')
    
    # Generate clouds.yaml
    clouds_config = generate_clouds_yaml()
    
    # Print out the configuration for verification
    print(yaml.dump(clouds_config, default_flow_style=False))

if __name__ == "__main__":
    main()