#!/bin/sh
terraform remote config -backend=S3 -backend-config="bucket=sl-chasopys-demo-config-prod" -backend-config="key=chasopys-demo.tfstate" -backend-config="region=us-east-1"
