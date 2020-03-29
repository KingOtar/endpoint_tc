# endpoint_tc
This project is a technical DevOps challenge for endpoint. (Let me know when you get it and I will delete it.

## About
This is a terraform project that will spin up all the needed resources for deploying a `ghost` container in a managed beanstalk cluster using AWS CodeBuild and ECR.

## File Structure
```
.
├── README.md - How to use this repo.
├── build_files (Files used by init.sh to start CodeBuild)
│   ├── Dockerfile
│   └── buildspec.yml
├── deploy_files (Files used by init.sh to deploy the application to beanstalk.
│   └── Dockerrun.aws.json
├── endpoint_challenge_tf -- Main terraform folder. Run terraform apply here
│   ├── main.tf
│   ├── output.tf (Outputs used by init.sh
│   ├── providers.tf
│   ├── terraform.tfvars (Only needs project name)
│   └── variables.tf
├── init.sh (Script to initialise repo, build image, push to ecr, and deploy to existing beanstalk infrastructure)
└── modules_tf
    ├── modules (All terraform modules)
        ├── main.tf
        ├── output.tf
        └── variables.tf

 ```

## How to use
1. First provide aws keys to terraform in any matter you wish either by using a default profile, environment variables, or updating the providers file with your aws credentials.

2. Run `terraform apply` in the endpoint_challenge_tf folder.

3. Run `./init.sh` in the root folder.

4. Access the application!

## Things to consider

- I hardcoded the `us-east-1` region. I left the code in a state where I would need to variablize a few terraform properties to allow deploying into other regions.
- I am checking to make sure a few cli tools are installed but not which versions. It would be safest to have all the latest versions for `terraform`, `aws`, and `eb`.
- I could have used more error checking in the init script especially in the polling for the build job. (iterate)
- I didn't manage to setup SSL termination on the beanstalk application, so `eb open` won't work as is. Just need to try http. (also would iterate)

## Thank you
I appreciate the opportunity to work on this project. I hope it all goes well and I thought of most use cases, but please let know if you have questions or concerns and I will do my best to address them.
