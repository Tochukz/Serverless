# Serverless LAMP Stack
[GitHub Code Examples](https://github.com/aws-samples/php-examples-for-aws-lambda)  

## Chapter 1: Introducing the new Serverless LAMP stack
[Introduction to new Serverless Lamp stack](https://aws.amazon.com/blogs/compute/introducing-the-new-serverless-lamp-stack/)  

__Notable AWS features for PHP developers__
1. Amazon Aurora Serverless
2. Lambda Layers and custom runtime API.  
3. Amazon RDS Proxy
[Lambda Layers](https://docs.aws.amazon.com/lambda/latest/dg/chapter-layers.html)   
[Custom Runtimes](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-custom.html)   
[Amazon RDS Proxy](https://aws.amazon.com/rds/proxy/)   

__Custom runtime API__  
The custom runtime API is a simple interface to enable Lambda function execution in any programming language or a specific language version. The custom runtime API requires an executable text file called a bootstrap which  is responsible for the communication between your code and the Lambda environment.  

[AWS Lambda Custom Runtime for PHP: A Practical Example](https://aws.amazon.com/blogs/apn/aws-lambda-custom-runtime-for-php-a-practical-example/)

## Chapter 2:


## Chapter 4: PHP Runtime on AWS Lambda using Bref Serverless Framework
[Bref Docs](bref.sh/docs)    
[Laravel Bridge](github.com/brefphp/laravel-bridge)  
Bref uses the Serverless Framework to configure and deploy serverless applications.

__Setup__  
To use Bref, you will need to prepare the following prerequisites  
1. AWS account
2. Serverless CLI
```
$ npm install -g serverless
```
3. AWS CLI Credentials

#### Serverless Laravel
You can run Laravel application on AWS Lambda using Bref.  
__Installation__   
Install the _Laravel-Bref package_ in an existing Laravel application.
```
$ composer require bref/bref bref/laravel-bridge --update-with-dependencies
```

__Generate a serverless.yml file__  
Publish a serverless configuration using _artisan_
```
$ php artisan vendor:publish --tag=serverless-config
````
This will generate a _serverless.yml_ file.

__Deployment__  
First clear the cache so as not to deploy dev config cache. After that you can run serverless deploy.
```
$ php artisan config:clear
$ serverless deploy
```
You can deploy to different environment using the `--stage` option
```
$ serverless deploy --stage=development
```

__Serving static assets__  
You can use the _ServeStaticAssets_ middleware to serve static assets.
To do so, you first publish a configuration using artisan
```
$ php artisan vendor:publish --tag=bref-config
```
This will generate a _config/bref.php_ file.  
Update the _config/bref.php_ file with the assets that you want to server.  
Update you enfironment varibles in the serveless.yml config file with
```
BREF_BINARY_RESPONSES: 1
```
This tells Bref to support binary responses on your web function.
