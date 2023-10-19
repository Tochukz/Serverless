# PHP Runtime 

__Description__  
The goal of this configuration is to build a PHP runtime for Lambda function.  
This runtime can then be used later to run a PHP application on AWS Lambda using the custom runtime API.  


__Setup__  
Generate RSA keypair  
```bash
$ ssh-keygen -q -f keys/simple-amz-linux.pem -C "Simple AMZ SSH key" -N ''
```

Prepare files for copying to EC2 instance 
```bash
$ cd ~/www/lab/
$ zip -r database.zip database
$ zip -r bootstrap.zip bootstrap
```

Copy composer.json file to the EC2 instance
```bash
$ scp -i keys/simple-amz-linux.pem ~/www/lab/composer.json ec2-user@13.40.23.76:~/php-layer/php/lib
$ scp -i keys/simple-amz-linux.pem -r ~/www/lab/database.zip ec2-user@13.40.23.76:~/php-layer/php/lib
$ scp -i keys/simple-amz-linux.pem -r ~/www/lab/artisan ec2-user@13.40.23.76:~/php-layer/php/lib 
$ scp -i keys/simple-amz-linux.pem -r ~/www/lab/bootstrap.zip ec2-user@13.40.23.76:~/php-layer/php/lib
```

SSH into the EC2 instance and install dependencies 
```bash
$ cd ~/php-layer/php/lib
$ unzip database.zip
$ unzip bootstrap.zip
$ composer install 
```