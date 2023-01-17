resource "null_resource" "install_dependencies" {

  provisioner "local-exec" {
    command = "${path.module}/lambda/build.sh"
  }
  triggers = {
    handler      = filemd5("${path.module}/${var.lambda_root}/handler.py")
    requirements = filemd5("${path.module}/${var.lambda_root}/requirements.txt")
    build        = filemd5("${path.module}/${var.lambda_root}/build.sh")
  }
}

# Now, in order to ensure that cached versions of the Lambda aren't invoked by AWS, 
# let's give our zip file a unique name for each version. 
# We can do with by hashing our files together.
resource "random_uuid" "lambda_src_hash" {
  keepers = {
    for filename in setunion(
      fileset("${path.module}/${var.lambda_root}", "handler.py"),
      fileset("${path.module}/${var.lambda_root}", "requirements.txt"),
      fileset("${path.module}/${var.lambda_root}", "build.sh")
    ):
        filename => filemd5("${path.module}/${var.lambda_root}/${filename}")
  }
}

data "archive_file" "lambda_source" {
  source_dir  = "${path.module}/${var.lambda_root}"
  output_path = "${path.module}/${var.lambda_root}/${random_uuid.lambda_src_hash.result}.zip"
  type        = "zip"

  depends_on  = [null_resource.install_dependencies]
  excludes    = [
    "__pycache__",
    "venv",
    "package",
  ]
}