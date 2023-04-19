__Deploy the application__  
```
$ serverless deploy
```  

__Cleanup__  
```
$ serverless remove 
```

__Deploy the stack__  
```
$ aws cloudformation deploy --stack-name NestServerless --template-file NestServerless.yaml
```

__Remove the stack__  
```
$ aws cloudformation delete-stack --stack-name NestServerless
```