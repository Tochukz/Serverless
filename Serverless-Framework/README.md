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


## Chapter 2: Traditional ExpressJS application with Serverless
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

## Chapter 3: Traditional NestJS application with Serverless  
__Description__  
Here we create our own NestJS application using the _Nest CLI_ and then modify it to run in a Lambda environment using the Serverless framework.  

#### Setup
1. __Create a new NestJS application__  
```
$ nest new nest-store
```  
2. __Install dependencies__  
```
$ npm install @vendia/serverless-express  
$ npm install --save-dev serverless-jetpack
```
3. __Add serverless.yml__  
Add a basic _serverless.yml_ configuration file
```bash
# serverless.yml
service: nest-store
frameworkVersion: '3'
plugins:
    - serverless-jetpack
provider:
    name: aws
    runtime: nodejs18.x
    region: eu-west-2
functions:
    api:
      handler: dist/lambda.handler
      events:
        - httpApi: '*'  
```
4. __Add a lambda handler__  
```
# lambda.ts
import { configure as serverlessExpress } from '@vendia/serverless-express';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
let cachedServer;
export const handler = async (event, context) => {
  if (!cachedServer) {
    const nestApp = await NestFactory.create(AppModule);
    await nestApp.init();
    cachedServer = serverlessExpress({ app: nestApp.getHttpAdapter().getInstance() });
  }

  return cachedServer(event, context);
}
```   

5. __Deploy the application__   
```
$ nest build
$ serverless deploy
```

## Chapter 4: Working with the Serverless.yml file
#### Deploying
__Deploy all__  
To deploy all your Functions, Events and Resources defined in your _Serveless.yml_ file,
```
$ serverless deploy
```  
You may use the `--force` flag to enforce deployment or the `--config` flag to specify a different configuration file.

__Deploy Function__  
This deployment method  simply overwrites the zip file of the current function on AWS. It is much faster, since it does not rely on CloudFormation.
```
$ serverless deploy function --function myFunction
```  
You can use `--update-config` to change only Lambda configuration without deploying code.  

__Deploying a Package__  
The deploy method takes a deployment directory that has already been created with `serverless package` command and deploys it to the cloud provider.  
```
$ serverless deploy --package path-to-package
```

#### Packaging
__Packaging CLI command__  
Running the following `package` command will build and save all of the deployment artifacts in the service's `.serverless` directory
```
$ serverless package
```
You can use the `--package` option to change the destination path.

__Packaging Configuration__    
The `package` section of the configuration describe how the application should be packaged.  

```bash
service: my-service
package:
  patterns:
    - "!node_modules" # excludes node_modules
```
You can use `patterns` to specify what directory or file to exclude and `serverless` will exclude them while packaging your application.  
Or you can use `artifact` to specify your own already packaged application
```bash
service: my-service
package:
  artifact: path/to/dist.zip
```
You artifact may point to an S3 object.
```bash
service: my-service
package:
  artifact: s3://bucket/path/to/dist.zip
```
Above we specify package at the service level, but package me be defined at the function level, and it could also be an S3 object.   

```bash
function:
  api:
    handler: lambda.handler
    package:
      artifact: s3://bucket/path/to.zip

```

#### Testing
Write your business logic so that it is separate from your _FaaS_ provider (e.g., AWS Lambda), to keep it provider-independent, reusable and more easily testable.  

#### Serverless Framework Services

## Chapter 5: Serverless and Dotnet
### Setup  
It is assumed that you already have _dotnet_ installed so the you can run `dotnet` commands on your terminal.

__Install dotnet lambda tool__  
```
$ dotnet tool install -g Amazon.Lambda.Tools
$ dotnet lambda --help
```  

__Install dotnet lambda test tool__  
```
$ dotnet tool install -g Amazon.Lambda.TestTool-6.0
$ dotnet tool list -g
```

__Installl VSCode C# extension__  
If you are using VSCode, install the C# extension if you have not already done so.  
```
$ code --install-extension ms-dotnettools.csharp --force
```  

For how to debug locally, read [How to Debug .NET Core Lambda Functions Locally](https://itnext.io/how-to-debug-net-core-lambda-functions-locally-with-the-serverless-framework-dd1670bc22e2)

#### Serverless template for Dotnet  
__Create dotnet serverless project__  
Here we create a dotnet serverless application using a serverless dotnet template
```
$ serverless --template-url https://github.com/pharindoko/serverlessDotNetStarter
```
Following the prompt, enter a project name. I named my application _NetApp_.
Restore the project dependencies
```
$ cd NetApp
$ dotnet restore
```  
__Build and deploy the application__  
```
$ ./build.sh
$ serverless deploy
```
For windows, execute the `build.cmd` script instead.  
The build script will build and package the code to the path `bin/release/net6.0/hello.zip`.  

__Setup local testing__  
To configure the application for local testing, update the `.vscode/launch.json` file and replace the `{user}` in the line
```
"program": "/Users/{userid}/.dotnet/tools/dotnet-lambda-test-tool-6.0",
```
with your username of your system.  
To start the local debugging, press F5. This will start a debugging session and fireup the browser with a testing interface similar to AWS Lambda Console event test interface.

__Clean up__  
```
$ serverless remove
```

#### Traditional dotnet application with Serverless  
Here we create a traditional dotnet application using _dotnet_ cli and then configure the application for Lambda.   
__Create a dotnet MVC project__  
```bash
# List the dotnet templates and select shortname the one to use
$ dotnet new list
$ mkdir NetStore
$ cd NetStore
# create dotnet mvc project without authentication
$ dotnet new mvc -au None
# start the application
$ dotnet run
$ curl http://localhost:5109
```
Replace the url for the curl command with the url generated when you run the application.  

__Create a dotnet WebApi project__  
```
$ mkdir NetStoreAPI
$ dotnet new webapi -au None
$ dotnet run
$ curl http://localhost:5288/WeatherForecast
```
Remember to replace the port with the port number of the generate url when you run the application.  

__Configure the dotnet application for Lambda__  
Fisrt, install the `Amazon.Lambda.AspNetCoreServer.Hosting` nuget package.
```
dotnet add package Amazon.Lambda.AspNetCoreServer.Hosting --version 1.6.0
```
Update the `Program.cs` file and add the following line
```
builder.Services.AddAWSLambdaHosting(LambdaEventSource.HttpApi);
```

[Building a Serverless ASP.NET Core Web API with AWS Lambda using Function URLs](https://coderjony.com/blogs/building-a-serverless-aspnet-core-web-api-with-aws-lambda-using-function-urls)  

## Chapter 6: Serverless and PHP
Todo: read this [Introducing the new Serverless LAMP stack](https://aws.amazon.com/blogs/compute/introducing-the-new-serverless-lamp-stack/)

## Learn more
How to configure serverless template [serverless.yaml](https://www.serverless.com/framework/docs/providers/aws/guide/serverless.yml)  
[Deploy a NestJS API to AWS Lambda with Serverless Framework](https://dev.to/aws-builders/deploy-a-nestjs-api-to-aws-lambda-with-serverless-framework-4poo)  
