# WORKMOTION-assignment

Implement infrastructure as code (IaC) for a simple web application that runs on AWS Lambda that prints the request header, method, and body for only GET and POST methods.

## Implementation overview
The client makes a call to an HTTP endpoint sends requests that are intercepted by API gateway which will take care of managing the traffic of the request. It will send the request to AWS Lambda which will print back the custom message.

## Prerequisites

#### Install AWS CLI
1. [Install AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
2. Get AWS CLI credentials
3. Go to [AWS Console: IAM](https://console.aws.amazon.com/iam/home)
4. Create a user with AdministratorAccess permission
4. Select **Security Credentials**
5. Select **Access Key ID** and **Secret access key**
6. Configure AWS CLI, run `aws configure` with the above parameters.

#### Install Docker
You will need to install [Docker](https://docs.docker.com/engine/installation/) and [Docker Compose](https://docs.docker.com/compose/install/) to get the app running locally in your machine.

#### Setup Github actions user
1. Go to [AWS Console: IAM](https://console.aws.amazon.com/iamv2/home#/users)
2. Select **Add users** with only Access key - Programmatic access
3. Select **Next Permissions**
4. Select **Create policy** and give the user the custom permission inside github-policy/github-policy.json
5. Select **Access Key ID** and  **Secret access key**
6. Create two github secrets AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY with the above parameters.

## CICD implementation
We have one sample github actions workflow that is triggered on push to main or to developer branches and perform below scenarios:
-  If pushed to main, a production deployment will be rolled out.
-  If pushed to developer, a development deployment will be rolled out.

#### Test the stack on Github
Create a main and/or developer branch, make a push event and watch the deployment to the associated environment.

## Local implementation
You can access and deploy to $ENV (production or development) as follow:
1. chose the environment you want to destroy
````
  docker-compose run --rm terraform workspace select $ENV
````
2. Plan the whole stack
````
  docker-compose run --rm terraform plan
````
3. Apply the whole stack
````
  docker-compose run --rm terraform apply
````

## Clean the Stack
1. chose the environment $ENV you want to destroy
````
  docker-compose run --rm terraform workspace select $ENV
````
2. destroy the whole stack
````
  docker-compose run --rm terraform destroy
````