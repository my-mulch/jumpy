#!/bin/sh

mkdir -p ~/.aws

echo -e "[default]\nregion = us-west-2\noutput = json" >~/.aws/config
echo -e "[default]\naws_access_key_id = $1\naws_secret_access_key = $2" >~/.aws/credentials

zip -r package.zip .

ls -lah

aws lambda get-function \
    --function-name numpy-endpoint \
    --output text \
    &>response

if grep -q "An error occurred" response; then
    aws lambda create-function \
        --function-name numpy-endpoint \
        --runtime python3.7 \
        --zip-file fileb://package.zip \
        --handler lambda_function.lambda_handler \
        --role arn:aws:iam::718734850255:role/service-role/admin
else
    aws lambda update-function-code \
        --function-name numpy-endpoint \
        --zip-file fileb://package.zip
fi
