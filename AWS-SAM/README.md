# AWS Serverless Application Model (SAM)
[AWS SAM](https://aws.amazon.com/serverless/sam/)   
[Developer Guide](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html)  

## Introduction
__AWS SAM Components__  
AWS SAM is made up of two Components
1. AWS SAM template specification
2. AWS SAM command line interface (AWS SAM CLI).

__Benefits of using AWS SAM__  
1. __Single-deployment configuration__  
 You can organize related components and resources, and operate on a single stack and deploy all related resources together as a single, versioned entity.
2. __Extension of AWS CloudFormation__  
You can define resources by using AWS CloudFormation in your AWS SAM template. Also, you can use the full suite of resources, intrinsic functions, and other template features that are available in AWS CloudFormation.  
3. __Built-in best practices__   
You can define and deploy your infrastructure as config, enforce best practices such as code reviews and  enable safe deployments through CodeDeploy, and can enable tracing by using AWS X-Ray.
4. __Local debugging and testing__  
AWS SAM CLI lets you locally build, test, and debug serverless applications that are defined by AWS SAM templates in a local Lambda-like execution environment to build.  
5. __Deep integration with development tools__  
You can use AWS SAM with a suite of AWS tools for building serverless applications. To build a deployment pipeline for your serverless applications, you can use CodeBuild, CodeDeploy, and CodePipeline.
You can discover new applications in the AWS [Serverless Application Repository](https://docs.aws.amazon.com/serverlessrepo/latest/devguide/what-is-serverlessrepo.html).

__AWS SAM CLI__   
Prerequisites
1. Docker (For testing locally)
2. AWS CLI  
To install SAM CLI on Mac using homebrew
```
$ brew tap aws/tap
$ brew install aws-sam-cli
```  
[Installing the AWS SAM CLI on Mac, Linux, Window](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html)  
[AWS SAM CLI command reference](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-reference.html)  

__AWS Tookkit for VSCode__  
[AWS Toolkit for Visual Studio Code](https://aws.amazon.com/visualstudiocode/)

## Chapter 1: Getting Started
__New AWS SAM application__  
To scaffold the application run the _init_ command and follow the prompt to select an application template and runtime.  
```
$ sam init
```
You can also write your own custom scaffolding templates and specify them using the location flag.   
```
$ sam init --location git+ssh://git@github.com/aws-samples/cookiecutter-aws-sam-python.git  
```  
For TypeScript template, make sure to install `esbuild` globally on your local machine.  
```
$ npm install -g esbuild
```
To build your application
```
$ cd hello-app
$ npm install
$ sam build
```
__Deployment__  
To validate SAM template
```
$ sam validate
```  
To deploy your application, run the `deploy` command with the `--guided` flag and follow the prompt to provide parameters for the _samlconfig.toml_ file.
```
$ sam deploy --guided
```

__Clean up__  
After you are done, you can remove all the AWS resources provisioned by your application by deleting the AWS CloudFormation stack that was deployed by SAM.
```
$ aws cloudformation delete-stack --stack-name hello-app  
```  

__Testing Locally__  
To use the AWS SAM CLI to test locally, you must have Docker installed and configured.  
Install Docker desktop for MacOS  from [docker for desktop](https://docs.docker.com/desktop/) and start docker by launching the docker desktop from Applications folder. Check if docker is running
```
$ docker ps
```
Checkout the installed extensions
```
$ docker info
```

The AWS SAM CLI provides the `sam local` command to run your application using Docker containers that simulate the execution environment of Lambda. There are two options to do this:
1. Host your API locally.
2. Invoke your Lambda function directly.
To host you API locally
```
$ sam local start-api --port 8080
```  
This will output a local endpoint for your API.  

To Invoke your Lambda function directly
```  
$ sam local invoke HelloWorldFunction -e events/event.json
```  
The will output the response of the triggered function.   

__The SAM Template__  
The SAM template represents the architecture of your Serverless application. The template file is _template.yaml_ file found at the root of your SAM application.   
SAM templates are an extension of CloudFormation templates. Any resource that you can declare in CloudFormation, you can also declare in a SAM template.  

__Useful Resources__  
[AWS Lambda Custom Runtime for PHP: A Practical Example](https://aws.amazon.com/blogs/apn/aws-lambda-custom-runtime-for-php-a-practical-example/)     
[The Complete AWS SAM Workshop](https://catalog.workshops.aws/complete-aws-sam/en-US)   

## Chapter 5: Serverless and Dotnet
### Setup and installations
It is assumed that you already have _dotnet_ installed so that you can run `dotnet` commands on your terminal.

__Install dotnet lambda tool__  
```
$ dotnet tool install -g Amazon.Lambda.Tools
$ dotnet lambda --help
```  
If you already have the tool installed and need to update
```
$ dotnet tool update -g Amazon.Lambda.Tools
```

__Install dotnet lambda test tool__  
```
$ dotnet tool install -g Amazon.Lambda.TestTool-6.0
$ dotnet tool list -g
```

__Dotnet CLI Templates__  
Next, we install the _Amazon.Lambda.Templates_ NuGet package which adds new templates to you _dotnet new_ collection.  
These new template supports Lambda function out of the box.  
```
$ dotnet new -i "Amazon.Lambda.Templates::*"
```  
This should list the newly installed Lambda templates after install.    
Now when you run `dotnet new list` all the Lambda template will be included along with the traditional template.  
To list only the Lambda templates
```
$ dotnet new list Lambda
```

__Install VSCode C# extension__  
If you are using VSCode, install the C# extension if you have not already done so.  
```
$ code --install-extension ms-dotnettools.csharp --force
```  

__Create new project Lambda project__  
Create a new project using one of the Lambda Template's shortname
```
$ mkdir LambAPI
$ cd LambAPI
$ dotnet new serverless.AspNetCoreWebAPI
$ dotnet new gitignore
```
You can take advantage of the _Lambda ASP.NET Core Minimal API_ template.
```
$ mkdir LambMinAPI
$ cd LambMinAPI
$ dotnet new serverless.AspNetCoreMinimalAPI
$ dotnet new gitignore
```
Minimal APIs are ideal for microservices.    
Learn more about [Minimal API with ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/tutorials/min-web-api?view=aspnetcore-7.0&tabs=visual-studio)

__Deploy the application__  
```
$ cd LambAPI/src/LambAPI
$ cp serverless.template template.json
$ sam validate
$ sam deploy --stack-name LambAPI --guided
```
Follow the prompt and make sure the say yes to the quest: "Save arguments to configuration file".  A _samconfig.toml_ file will be created after the deploy.  

__Cleanup__  
```
$ sam delete
```

__Debugging__  
For how to debug locally, read [How to Debug .NET Core Lambda Functions Locally](https://itnext.io/how-to-debug-net-core-lambda-functions-locally-with-the-serverless-framework-dd1670bc22e2)

__Learn more__  
[AWS Lambda Dotnet](https://github.com/aws/aws-lambda-dotnet)
[Building a Serverless ASP.NET Core Web API with AWS Lambda using Function URLs](https://coderjony.com/blogs/building-a-serverless-aspnet-core-web-api-with-aws-lambda-using-function-urls)  
