# serverless-dice-distribution-simulation
This solution builds an API gateway that addresses two lambda functions. 
The first lambda function `dice-roller` simulates dice rolls, with variable number of dice, dice eyes and number of dice rolls.
The second Lambda function `get-results` returns the total number of simulations and total rolls made, grouped by all existing dice number–dice side combinations
anm for a given dice number–dice side combination, the relative distribution, compared to the total rolls, for all the simulations.

## Prerequisites
Terraform version >= 1.0

## Deployment
To deploy the solution you need to use `terraform init` and `terraform apply` and the following directories and order:
1. `terraform-remote-backend`
2. `application/dynamodb`
3. `application/lambda/dice-roller`
4. `application/lambda/get-results`
5. `application/api`

The Lambda functions are written in Node.js but don't need any external packages, so no npm is needed.

## Important decisions
* This project uses a remote backend for Terraform. The reason for this is that it is so easy to work in a team with terraform, and you get features like lock management, state versioning and permissions.
* The Lambda functions are written in Node.js because it is an easy-to-use script based programming language and as such perfect for Lambda functions. The code is so small that it can be deployed directly in the Lambda function. In a larger project, the build and deployment of the Lambda functions would rather be outsourced to a separate build pipeline and the code deployed in an S3 bucket. 
* A DynamoDB was used as the database because this NoSQL database from AWS is perfect for large amounts of data and scales wonderfully. the code here manages to write millions of rolls with thousands of dice and dice eyes in less than 30 seconds and partition them so that they can be read out in a minimum of time. 

## Architecture Questions
1. How would you publish the API? The API uses the serverless API service from AWS. Because of this the API is "infrastructure" and can be deployed with IaaC tools like Terraform. 
2. How would you pen-test/secure the API? You can secure the Amazon API Gateway with built-in functionality like WAF integration, rate limits, authentication with Cognito and more, AWS Shield. For Pen-test I would hire experts, like Qnit.
3. How would you test the quality of the API? Because everything is written in infrastructure as code we can use the same quality pipelines like with "normal" code. For example every change will be introduced through a Git pull requests. If a pr does not comply with the quality guidelines, it can be rejected before changes are applied to a stage.
4. How would you monitor the Lambda functions? The most important Lambda metrics are already populated to CloudWatch. In CloudWatch you can set alarms on metrics to get informed if a metric is suspicious.
