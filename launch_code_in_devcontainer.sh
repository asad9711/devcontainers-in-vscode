#!/bin/bash


#  clone the url, cd into that,
#  check if devcontainer file is present, if not present, log a line that its not present and you are adding one
#  add a launchable devcontainer.json file
#  and then run the command to open that folder in devcontainer



# Accept the CLI argument named "bitbucket_repo_url"
bitbucket_repo_name=$1
bitbucket_repo_branch=$2

# delete if folder exists
rm -rf $bitbucket_repo_name

# Git clone the URL
git clone git@bitbucket.org:<org_name>/$bitbucket_repo_name.git -b $bitbucket_repo_branch;

# Change directory to the cloned repository
cd $bitbucket_repo_name

# Check if devcontainer file is present
if [ -f .devcontainer/devcontainer.json ]; then
    echo ".devcontainer/devcontainer.json file exists."
else
    echo ".devcontainer/devcontainer.json file is not present. Adding one..."
    
    mkdir -p .devcontainer

    # Add a launchable devcontainer.json file

    # Check if docker-compose.yml file is present
    if [ -f docker-compose.yml ]; then
        echo "docker-compose.yml file exists."
        # Create a sample devcontainer.json file for Docker Compose
        echo '{
            "name": "$bitbucket_repo_name",
            "dockerComposeFile": "../docker-compose.yml",
            "service": "app",
            "workspaceFolder": $bitbucket_repo_name
        }' >> .devcontainer/devcontainer.json
        echo "Sample .devcontainer/devcontainer.json file for Docker Compose created."
    elif [ -f Dockerfile ]; then
        echo "Dockerfile exists."
        # Create a sample devcontainer.json file for Docker
        echo '{
            "name": "$bitbucket_repo_name",
            "build": {
                "dockerfile": "Dockerfile",
                "context": ".."
            },
            "workspaceFolder": $bitbucket_repo_name
        }' >> .devcontainer/devcontainer.json
        echo "Sample .devcontainer/devcontainer.json file for Docker created."
    else
        echo "Error: Neither docker-compose.yml nor Dockerfile found."
        exit 1
    fi
fi

# check if docker compose if present, if not check for Dockerfile, else log error and exit
# Run the command to open the folder in devcontainer
# code .
code --folder-uri="vscode-remote://dev-container+$(pwd | tr -d '\n' | xxd -p)/workspaces/$(basename "$(pwd)")"

# this code is tightly coupled with bitbucket, with a minor tweak, can be updated for any remote code hosting provider