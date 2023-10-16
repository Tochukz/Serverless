# PHP Runtime 

__Description__  
The goal of this configuration is to build a PHP runtime for Lambda function.  
This runtime can then be used later to run a PHP application on AWS Lambda using the custom runtime API.  


__Setup__  
Generate RSA keypair  
```bash
$ openssl genrsa -out runtime-key.pem
$ openssl rsa -pubout -in runtime-key.pem -out runtime-key.pub.pem
```