region             = "us-east-1"
name               = "ztpt-worker"
deployment_package = "demo"
stage              = "test"

function_name      = "welcome"
handler            = "handler.handler"
runtime            = "python3.9"