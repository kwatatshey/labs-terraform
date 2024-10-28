# Airflow EKS AWS infrastructure terraform

This repository contains terraform files needed to manage all AWS infrastructure components for Airflow on EKS.

It contains modules and .tf files to manage all environments, all AWS regions and all Airflow instances.

There are two main terraform configurations to deploy.
- Region level - infrastructure to be deploy once per envrionment and aws region. Multiple Airflow instance can then reuse this infra. Example is EKS cluster
- Instance level - infrastructure used by a single Airflow instance. Example is RDS database

Repository structure looks as follow:
```
.
├── deployments
│   ├── env1
│   │   └── region1
│   │       ├── instances
│   │       │   ├── projectA
│   │       │   │   └── projectA-main.tf
│   │       │   └── projectB
│   │       │       └── projectB-main.tf        
│   │       └── region-main.tf
│   └── env2
│       └── region2
│           ├── instances
│           │   ├── projectA
│           │   │   └── projectA-main.tf
│           │   └── projectB
│           │       └── projectB-main.tf        
│           └── region-main.tf    
├── modules
├── scripts
├── templates
│   ├── <project>-<env>
│   └── <region>
└── .gitignore
```

modules - contains terraform modules that are reused across all instances

scripts - contains reused scripts

templates - contains templates with placeholders that are used when deploying new region or Airflow instance

deployments - contains actual configuration files divided by environment, region and instance

## Run terraform commands for existing infra
Navigate to correct folder in deployments:

- ***deployments/environment/region*** to manage region level infrastructure

- ***deployments/environment/region/instances/project*** to manage project level infrastructure

Examples:

- to manage region level infrastructure for environment "sit" and region "us-east-1" go to ***deployments/sit/us-east-1***

- to manage instance level infrastructure for environment "sit", region "us-east-1" and project "mrlsls" go to ***deployments/sit/us-east-1/instances/mrlsls-sit***

## Deploy new infrastructure

Navigate to templates/ and copy \<region> folder for region level deployment or \<project>-\<env> folder for instance level deployment. (One is to prepare new region and second is to deploy new Airflow instance to an existing region)

Paste the folder to correct place under deployments folder.

Rename the copied folder and files to match target deployment env, region and project

Configure provider*.tf and variable-values*.tfvars files

At minimum in provider*.tf setup proper s3 backend and in variable-values*.tfvars this deployment specific values.

You can now run terraform init and terraform apply from given folder.

 
***After changes to .tf files are done, commit everything back to remote repository***