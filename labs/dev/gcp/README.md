#Google Cloud - DEV

## gcloud auth login

Although it is not the best practice, you can use the following command to login to your GCP account from the command line. This will create a file in your home directory called .config/gcloud/application_default_credentials.json. This file will be used by Terragrunt to authenticate to GCP.

This Method allows you to start running quickly from you local machine. However, it is not recommended for production use.

```bash
gcloud auth application-default login
```

## What
