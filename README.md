# Serverless
## AWS Serverless
[Getting started with AWS Serverless](https://aws.amazon.com/serverless/getting-started/)  

__Introduction__  
A serverless application is a combination of Lambda functions, event sources, and other resources that work together to perform tasks. A serverless application is more than just a Lambda function, it can include additional resources such as APIs, databases, and event source mappings.  

### Frameworks
1. AWS Serverless Application Model ([AWS SAM](https://aws.amazon.com/serverless/sam/))
2. AWS Cloud Development Kit ([AWS CDK](https://aws.amazon.com/cdk/))
3. The Serverless Framework ([serverless.com](https://www.serverless.com))
4. Chalice framework for Python apps ([github.com/aws/chalice](https://github.com/aws/chalice))  
5. Arc.code ([arc.codes/docs](https://arc.codes/reference/arc/aws))
6. Claudia.js ([claudiajs.com/](https://claudiajs.com/claudia.html))

### AWS Serverless Application Model (SAM)
[AWS SAM](https://aws.amazon.com/serverless/sam/)   
[Developer Guide](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html)    
[CLI Reference](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-command-reference.html)   


### NestJS + AWS Lambda + Serverless framework
#### Tech Stack  
1. __Nest.js__  
A powerful framework for creating sever-side applications, [learn more](https://nestjs.com/).
2. __Serverless Framework__  
  Easy to use framework for developing and deploying serverless apps, [learn more](https://serverless.com/).
3. __Serverless Jetpack__    
A low-config plugin that packages our code to be deployed to AWS Lambda, [learn more](https://github.com/FormidableLabs/serverless-jetpack).
4. __Serverless Express__    
A library that makes our "plain" NestJS API play nicely with Serverless [learn more](https://github.com/vendia/serverless-express)
5. __AWS managed services__    
  Services like _Lambda_, _API Gateway_ and _RDS_.  

#### Setup   
__Install the Serverless Framework CLI__  
```
$ npm install -g serverless
```

__Install the serverless-jetpack plugin__  
```
$ npm install --save-dev serverless-jetpack
```

__Install the serverless-express library__  
```
$ npm install @vendia/serverless-express
```

__Add a serverless.yaml file__  
```
service: songs-api

frameworkVersion: '3'

plugins:
  - serverless-jetpack

provider:
  name: aws
  runtime: nodejs14.x
  region: eu-central-1 # or whatever your region is

functions:
  api:
    handler: dist/lambda.handler
    events:
      - http:
          method: any
          path: /{proxy+}
```

__Create a lambda.ts file in the src folder__  
The _lambda.ts_ file contains the Lambda handler function, which is the entry point, as referenced in the above _serverless.yaml_.  
```
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

__Deploy the application__  
```
$ serverless deploy
```  

__Cleanup__  
```
$ serverless remove
```

Very recently AWS announced Lambda [function URL](https://docs.aws.amazon.com/lambda/latest/dg/lambda-urls.html) feature, which eliminates the need for API Gateway but has other trade-offs.   

__Resources__  
[Deploy a NestJS API to AWS Lambda with Serverless Framework](https://dev.to/aws-builders/deploy-a-nestjs-api-to-aws-lambda-with-serverless-framework-4poo)    
