FROM alpine:latest

# Install terraform
RUN apk add --update --no-cache unzip wget
RUN wget https://releases.hashicorp.com/terraform/0.15.4/terraform_0.15.4_linux_amd64.zip && \
    unzip terraform_0.15.4_linux_amd64.zip -d /usr/local/bin/ && \
    rm terraform_0.15.4_linux_amd64.zip

# Set the working directory
WORKDIR /app

# Copy the Terraform files
COPY . .

# Run terraform commands
ENTRYPOINT ["terraform"]
CMD ["--help"]