from dotenv import load_dotenv
import os
import json

load_dotenv()

env_vars = {
    'NEXTCLOUD_DB_NAME': os.getenv('NEXTCLOUD_DB_NAME'),
    'NEXTCLOUD_DB_USER': os.getenv('NEXTCLOUD_DB_USER'),
    'NEXTCLOUD_DB_PASSWORD': os.getenv('NEXTCLOUD_DB_PASSWORD'),
    'NEXTCLOUD_TIMEZONE': os.getenv('NEXTCLOUD_TIMEZONE'),
}

print(json.dumps(env_vars))
