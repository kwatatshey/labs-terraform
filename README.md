# OpsFleet - Labs

## What is this?

This repo is a collection of infrastructure as code for various projects. The repo is using Terragrunt
as it's IaC tool.
This repository aims to provide a quick way to provision infrastructure for our most classic use cases.
It consists of an organization root-directory(labs) and a templates directory.

- Under the root directory you will find a directory structure that aims for scale and durability cross clouds.
- Under the templates directory you will find a collection of modules that can be used to provision infrastructure and common services.

## How to use this repo?

At the start of your project please review this readme file in detail. It is most likely that you won't need all of the components in this repo. So please take the time to understand what is available and what you need.

After you have reviewed the repo - please remove the components that you don't need and test your changes.

A few technical guidelines:

If you are using this repo as a start point for a new project :

- Please use it on a fork repo.
- Remove these guidelines from your forked repo - Since they are not relevant to the project's team.
- Don't deliver the whole repo since it holds the entire git history - deliver only the files that you need( remove the .git directory).

If you are using this repo as a contributor to our assets:

- Please create a branch for your changes.
- Please make sure to add a reviewer to you Pull-Request.
- And Thanks :)

### Directory Structure

This is a high level overview of the directory structure.Each level might contain more directories and files.

```bash
├── org_name(labs)
│   ├── environment(dev)
│   │   ├── cloud_provider(aws)
│   │   │   ├── account_alias(opsfleet_test_task)
│   │   │   │   ├── region(eu-west-1)
│   │   │   │   │   ├── Tech_Stack(stack01)
│   │   │   │   │   │   ├── component01(vpc)
│   │   │   │   │   │   ├── component02(eks)
├── templates(templates)
│   ├── terraform_module01(eks)
│   ├── terraform_module02(charts)
```

#### Explanation of the directory structure:

- org_name - the name of the organization that owns the infrastructure. This is the high level directory that holds all of the infrastructure HCL code.
- environment - Under the root directory we separate our infrastructure by environments. The most basic are Dev and Prod. At this point the code is still cloud agnostic. Their can be Dev environments on AWS and on GCP. This directory holds environment scoped vars and under it all of the environment specific infrastructure HCL code.
- cloud_provider - Under this directory we start managing cloud specific vars and files. Here we should generate state and provider files for the relevant cloud provider.
- account_alias - Under this directory we manage account specific vars and files. We are using the word account(since we use AWS terminology) but this can also represent a Google Cloud project.
- region - Under this directory we manage region specific vars and files.
- Tech_Stack - This directory represents a tech_stack in our project. A tech_stack is a collection of components that are deployed together. For example a VPC, 2 EKS clusters a DB and an SQS Queue. This directory holds the tech_stack specific vars and files.
- Component - This directory represents a component in our tech_stack. Some components such as K8S clusters might have child directories and some might represent a single terraform module deployment such as VPC.

## Perquisite's

#### Common Installations:

- [Terraform](https://www.terraform.io/downloads.html)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)

#### AWS Specific Installations:

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

#### GCP Specific Installations:

- [GCP CLI - gcloud](https://cloud.google.com/sdk/docs/install)

## How to use this repo?

For the simple example we will deploy our EKS cluster on AWS.

Steps to deploy:

- Clone this repo.
- cd to the root directory of the repo.
- Change the `account_alias` directory name to your account alias (if you're not using an existing test account, like `opsfleet_test_task` in our AWS org).
- Set the "parent_zone_id" variable to your parent zone id - can be found at - labs/dev/aws/opsfleet_test_task/account_specific.hcl
- cd to the relevant tech_stack directory - labs/dev/aws/opsfleet_test_task/eu-west-1/test-sk01
- run the following commands:

```bash
terragrunt run-all init
terragrunt run-all plan
terragrunt run-all apply
```

You should successfully deploy -

- Public VPC
- EKS Cluster
  - Creation of Hosted Zone for the cluster
  - Creation of IAM OIDC provider
  - Cluster Auto-scaler (With creation of SA and RBAC)
  - External DNS(With creation of SA and RBAC) - Connected to the new hosted zone
  - ALB Controller(With creation of SA and RBAC)
  - External Secrets Operator(With creation of SA and RBAC)

**_For Google Cloud [this]() is a good place to start_**
