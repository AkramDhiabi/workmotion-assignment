# WORKMOTION-assignment

Implement infrastructure as code (IaC) for a simple web application that runs on AWS Lambda and prints the request header, method, and body for only GET and POST methods.

## Implementation overview
The client makes a call to an HTTP endpoint sends requests that are intercepted by API gateway which will take care of managing the traffic of the request. It will send the request to AWS Lambda which will print back the custom payload.
- Deployment region: `eu-central-1`

## Prerequisites

#### Install AWS CLI
1. [Install AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
2. Get AWS CLI credentials
3. Go to [AWS Console: IAM](https://console.aws.amazon.com/iam/home)
4. Create a user that have `AdministratorAccess` IAM permission with access types `Access key - Programmatic access` and `Password - AWS Management Console access`
4. Select **Security Credentials**
5. Select **Access Key ID** and **Secret access key**
6. Configure AWS CLI, run `aws configure` using above parameters.

#### Create AWS resources on from AWS console
1. an S3 bucket to host terraform state named `fs-wm-app-state`
2. A DynamoDB table to handle state locking named `fs-wm-state` and should have primary key `LOCK_ID`

#### Install Docker
You will need to install [Docker](https://docs.docker.com/engine/installation/) and [Docker Compose](https://docs.docker.com/compose/install/) to get the app running locally in your machine.

#### Setup Github actions user
1. Go to [AWS Console: IAM](https://console.aws.amazon.com/iamv2/home#/users)
2. Select **Add users** with only access type `Access key - Programmatic access`
3. Select **Next Permissions**
4. Select **Create policy** and give the user the custom IAM permission inside `github-policy/github-policy.json`
5. Select **Access Key ID** and  **Secret access key**
6. Create two github secrets `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` using above parameters.

## CICD implementation
We have one main github actions workflow that is triggered on push to main or to developer branches and perform below scenarios:
-  If pushed to `main`, a `production` deployment will be rolled out.
-  If pushed to `developer`, a `development` deployment will be rolled out.

#### Test the stack on Github
1. Use `main` or create `developer` branch, make a push event and watch the deployment to the associated environment.
2. Once the deployment is done, get the `deployment_invoke_url` from the `Terraform Apply` output step .
3. Test the endpoint:
````
curl --header "Content-Type: application/json" \
     --data '{"username":"xyz","password":"xyz"}' \
     $deployment_invoke_url
````

## Local implementation
You can access and deploy to `$ENV` (production or development) as follow:
1. chose the environment you want to destroy:
````
  docker-compose run --rm terraform workspace select $ENV
````
2. Plan the whole stack:
````
  docker-compose run --rm terraform plan
````
3. Apply the whole stack:
````
  docker-compose run --rm terraform apply
````
4. Once the deployment is done, get the `deployment_invoke_url` from the `Terraform Apply` output step .
5. Test the endpoint:
````
curl --header "Content-Type: application/json" \
     --data '{"username":"xyz","password":"xyz"}' \
     $deployment_invoke_url
````
## Clean the Stack
1. chose the environment `$ENV` you want to destroy:
````
  docker-compose run --rm terraform workspace select $ENV
````
2. destroy the whole stack:
````
  docker-compose run --rm terraform destroy
````
3. Delete the workspace:
````
  docker-compose run --rm terraform workspace select default
  docker-compose run --rm terraform workspace delete $ENV
````