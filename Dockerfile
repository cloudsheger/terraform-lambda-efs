FROM hashicorp/terraform:0.15.0

# Install the AWS CLI
RUN apk add --update py-pip
RUN pip install awscli

# Set the working directory
WORKDIR /app

# Set the entrypoint
ENTRYPOINT ["terraform"]
