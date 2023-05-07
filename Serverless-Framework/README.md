# Serverless Framework
[Docs](https://www.serverless.com/framework/docs/)     
[Tutorial](https://www.serverless.com/framework/docs/tutorial)   
[CLI Reference](https://www.serverless.com/framework/docs/providers/aws/cli-reference/)   

## Chapter 1: Get started  
The Serverless Framework is a powerful deployment and development tool. It is an integral piece to cloud functions development.  

__Install serverless CLI__  
Install the Serverless Framework CLI
```
$ npm install -g serverless
```  
You can then access the serverless CLI using the `serverless` or `sls` command.  

__Setup__  
To create a new serverless project run
```
$ serverless create --template aws-nodejs --path aws-service
$ cd aws-service
$ npm init -y
$ npm install aws-sdk
```  
The template defines which cloud provider you are using along with the runtime. Similar templates for Azure and Google cloud are `azure-nodejs` and `google-nodejs` respectively.  The path defined the name of the service you are creating.  See the [example code](https://github.com/mgstigler/Serverless)

Another way to create a serverless application is to use the CLI wizard. Just run
```
$ serverless
```
and follow the prompt.   

You can also use the github repo as the value for the template flag
```
$ serverless --template-url=https://github.com/serverless/examples/tree/v3/aws-node-typescript-nest
```  
See [example serverless templates](https://github.com/serverless/examples) for more tables

After your serverless app is created you will be prompted to login or register for Serverless Dashbaord of which you should.     
Do not deploy to AWS if prompted to do so until you have setup the _provider_.  

__Provider__  
You need to connect an AWS account in order to grant the Serverless CLI permission to run Lambdas, access DynamoDB data, and probe other services.  
A provider is a mechanism to connect your Serverless account with AWS and other cloud service providers.  
The Serverless Framework provides a few options to enable connectivity: a _Simple automatic_ flow with generalised permissions, an _Access/Secret Key_ flow for manual configuration, and an _ARN option_ for ID-based role access.

__Create a Provider Manually__  
If you do not already have AWS CLI configured on you machine the serverless CLI wizard will lead you through creating a provider automatically, otherwise you will need to create it manually.  
To create a provider,
* Login to [app.serverless.com](https://app.serverless.com)
* Click on _Org_ menu on the left navigation bar
* Click on the _providers_ tab
* Click on the _add_ button and _next_
* For the provider, select the _Simple_ option
* Click _Connect AWS Provider_ and a new tab will open with the _AWS Cloud Formation_ console   
* Scroll down to the end of the page, check the confirmation box and click _Create Stack_ button.
* Wait a few second and refresh the page until the status says _CREATE_COMPLETE_ in green.  
* Close the Tab to go back the the Provider creation page.
* The provider page will should notice that the provider has been created. Click Done.

__Deployment__  
To deploy the project, `cd` into the project folder and
```
$ serverless deploy
```
The will use the provider you created or your AWS CLI credential to deploy to your AWS account.     
After the deployment, you should see the API endpoint in the terminal output.  

__API Info__  
To see details about your running serverless application
```
$ serverless info
```
This will show you the API endpoint and also the dashboard URL.  

__Monitoring__   
To monitor you serverless application, in the serverless app directory, run
```
$ serverless
```
This will configured your service on the Serverless Dashboard at https://app.serverless.com/your-username/apps/.  

__Invoke function__
To invoke your function directly, inside of your project directory, run
```
$ serverless invoke --function api
```

__Deploy on cloud faster__  
To deploy code changes quickly, skip the _serverless deploy_ command which is much slower since it triggers a full AWS CloudFormation update.  
Instead, deploy code and configuration changes to individual AWS Lambda functions in seconds via the _deploy function_ command, with _-f_ set to the function you want to deploy.
```
$ serverless deploy function --function my-api
```  
This command simply swaps out the zip file that your CloudFormation stack is pointing toward. This is a much faster way of deploying changes in code.  
__Caution:__ This puts your function in an inconsistent state that is out of sync with your CloudFormation stack. Use this for faster development cycles and not production deployments.


__Service logs__   
To view your service log, inside of your project directory, run
```
$ serverless logs
```

__The Serverless Dashboard__  
[Serverless Dashboard](app.serverless.com) is a tool provided by the Serverless Framework to help make managing connections to AWS easier, manage configuration data for your services, monitoring capabilities and the ability to read logs for your Lambda functions amongst many other features.  

__Delete App__   
To remove your service, run
```
$ serverless remove
```
This will delete all the AWS resources created by your project and also remove the service from Serverless Dashboard.

__Working Offline__  
Install the serverless-offline plugin in your project  
```
$ serverless plugin install -n serverless-offline
```  
To run the local emulator
```
$ serverless offline
```

__Configure AWS Access Key for Serverless CLI__  
```
$ serverless config credentials --provider aws --key XXXXXXXXXXX --secret XXXXXXXXXX
```
This is not needed if you have already configured AWS CLI on your machine.

## Serverless Framework Concepts
The Serverless Framework manages your code as well as your infrastructure
It supports multiple languages (Node.js, Python, Java, and more).  
Here are the Framework's main concepts and how they pertain to AWS and Lambda.

#### Functions
Each function is an independent unit of execution and deployment, like a microservice.  

#### Events
Functions are triggered by events. Events come from other AWS resources, for example:
* An HTTP request on an API Gateway URL (e.g. for a REST API)
* A new file uploaded in an S3 bucket (e.g. for an image upload)
* A CloudWatch schedule (e.g. run every 5 minutes)
* A message in an SNS topic

When you configure an event on a Lambda function, Serverless Framework will automatically create the infrastructure needed for that event

#### Resources
Resources are AWS infrastructure components which your functions use such as a DynamoDB table or an S3 bucket.
Anything that can be defined in CloudFormation is supported by the Serverless Framework.  

#### Services
A service is the Framework's unit of organization. You can think of it as a project file, though you can have multiple services for a single application.  

#### Plugins
You can overwrite or extend the functionality of the Framework using plugins.

__Alternative configuration format__   
You can also define the service configuration in JSON _(serverless.json)_, JavaScript _(serverless.js)_ or TypeScript _(serverless.ts)_.   

## Usage
#### Deploying
__Deployment method__  
It is possible to use CloudFormation direct deployments instead.  
Direct deployments are faster and have no downsides (unless you specifically use the generated change sets). They will become the default in Serverless Framework 4.  
```
provider:
  name: aws
  deploymentMethod: direct
```
__Tips__
* Use this in your CI/CD systems, as it is the safest method of deployment.
* use _verbose_ mode to print the progress during the deploymen, `serverless deploy --verbose`


## Chapter 2: Custom ExpressJS application with Serverless
__Description__   
In the previous chapter, we creates serverless application using the _serverless CLI_ tool and templates available in the Serverless framwework ecosystem.  
Here we create out own ExpressJS application using the _express-generator_ and then modify it to run in a Lambda environment using the Serverless framework.  

#### Setup
1. __Generate a new express application__  
First, generate the express application using the express-generator.  
```
$ npx express-generator --pug  xpress-store
$ cd xpress-store
$ npm install
```  
2. __Install the dependency__  
Second, install all the npm packages to provide serverless support for the application
```
$ npm install serverless-http
```
3. __Add a handler__  
The handler wraps your express app for serverless
```bash
# bin/handler.js
const serverless = require('serverless-http');
const app = require("../app");
module.exports.main = serverless(app);
```
4. __Add a basic serverless.yml file__  
```bash
# serverless.yml
service: xpress-store
frameworkVersion: '3'
provider:
    name: aws
    runtime: nodejs18.x
functions:
    api:
      handler: bin/handler.main
      events:
        - httpApi: '*'
```  

5. __Deploy the application__   
```
$ serverless deploy
```  
Copy the endpoint from the output and test it with a browser.  
The `.serverless` directory contains the app zip and CloudFormation template generate by the Serverless CLI.  

6. __Update the serverless.yml__  
You can then update the _serverless.yml_ file according to your application's need.   

## Chapter 3: Custom NestJS application with Serverless  
__Description__  
Here we create our own NestJS application using the _Nest CLI_ and then modify it to run in a Lambda environment using the Serverless framework.  

#### Setup
1. Create a new NestJS application
```
$ 
```

## Learn more
How to configure serverless template [serverless.yaml](https://www.serverless.com/framework/docs/providers/aws/guide/serverless.yml)  
