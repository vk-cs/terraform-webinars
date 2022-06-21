terraform {
    required_providers {
        vkcs = {
            source = "vk-cs/vkcs"
        }
    }
}

provider "vkcs" {
    # Your user account.
    username = "YOUR_ACCOUNT_EMAIL"

    # The password of the account
    password = "YOUR_ACCOUNT_PASSWORD"

    # The tenant token can be taken from the project Settings tab - > API keys.
    # Project ID will be our token.
    project_id = "PROJECT_ID"
    
    # Region name
    region = "RegionOne"
}

provider "tls" {
  proxy {
    from_env = true
  }
}