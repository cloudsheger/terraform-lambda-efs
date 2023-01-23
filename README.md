## Packaging the Lambda
So, we need our Lambda's dependencies to be packaged up with the source code so that aws_lambda_function can use it. Luckily, we can do this in Terraform using Terraform's null_resource and archive_file.

1. Install our lambda code dependencies.This will eventually package with the source code as a zipped file.

Create a script with build commands, build.sh
it navigates to the scripts directory and installs all requirements into the package directory.

#!/usr/bin/env bash

# Change to the script directory
cd "$(dirname "$0")"
pip install -r requirements.txt -t package/