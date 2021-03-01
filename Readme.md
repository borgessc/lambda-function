# Deploy Lambda Function 

These terraform files will help to deploy and execute the Lambda Function within AWS Serveless resource.

# AWS Profile 

To execute terraform within the environment, AWS credentials need to be set prior to start the deployment.

Visit: AWS IAM on AWS Web-UI and generate credentials for your access.

Once you have the `Access_key` and `Secret_Key`

Create a profile into AWS credentials file

~/.aws/credentials 

```
[user-root-test]
output=json
aws_access_key_id = A......6I
aws_secret_access_key = U.........lz
region = ap-southeast-2
aws_session_token =
```
## Installing Terraform

Terraform will be the main tool used to deploy this solution, to install and execute follow the steps below.
This recipe was written in terraform version 12, so download the latest version here
* Find your system version here https://releases.hashicorp.com/terraform/0.12.30/
* Download the binary https://releases.hashicorp.com/terraform/0.12.30/terraform_0.12.30_linux_amd64.zip
* Extract the bynary directly to your path

 e.g #`unzip terraform_0.12.30_linux_amd64.zip /usr/local/bin` 




## Deploying S3 bucket and Handler file

The `index.js` is the Lambda file that will running within AWS.

Located within `S3` folder just execute the following command below.

*Preparing the file for transfer*
```
zip index.js function.zip
```

Deploying the Bucket

The file don't need to be changed since is ready to deploy and execute.

Inicialize terraform
```
cd s3/
AWS_PROFILE=user-root-test terraform init
```

Plan the Bucket deployment and send the Object 
```
AWS_PROFILE=user-root-test terraform plan -var-file=ap-southeast-2.tfvars
```

Apply the terraform deployment and create the Bucket with Object Function included.
```
AWS_PROFILE=user-root-test terraform apply -var-file=ap-southeast-2.tfvars
```

##  Deploy Lambda and API Gateway 

Within the *main folder* the Lambda Function will be created and the api gateway to Provide external conectivity.
Use the same method to deploy the Function

Inicialize terraform
```
AWS_PROFILE=user-root-test terraform init
```

Deploy Lambda Function and API-GW
```
AWS_PROFILE=user-root-test terraform plan -var-file=ap-southeast-2.tfvars
AWS_PROFILE=user-root-test terraform apply -var-file=ap-southeast-2.tfvars
```

After deploy the Terraform recipe an output will be printed out to help you the get the results through Web URL
```
*e.g* https://6kiwsh1upd.execute-api.ap-southeast-2.amazonaws.com/test
```

# Manual Lambda validation

During the test running the api gateway from URL could returns some HTTP errors like (500), however aws has cli command `aws lambda invoke` that works to validade handlers function via CLI.

If for some reason the API-GW URL doesn't work it's possible to validate the Function running as show below.

```
AWS_PROFILE=user-root-test aws lambda invoke --region=ap-southeast-2 --function-name="ServerlessExample" output.txt
```

```
cat output.txt
{"statusCode":200,"body":"{\n  \"message\": \"All good! Your function executed successfully.\",\n  \"input\": {}\n}"}%
```




