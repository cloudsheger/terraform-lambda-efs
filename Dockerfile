FROM hashicorp/terraform:1.3.7

# Install Python 3 and pipenv
RUN apk add --no-cache python3
RUN python3 -m ensurepip
RUN pip3 install pipenv

# Install the AWS CLI
RUN pip3 install awscli

# Set the working directory
WORKDIR /app

# Set the entrypoint
#ENTRYPOINT ["terraform"]
