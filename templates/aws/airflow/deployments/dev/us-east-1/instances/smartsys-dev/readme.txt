1) Instance infrastructure was created with Cloudbees
   but with error creating Faragate profile (permission error)
2) Then infrastructure was updated via Terraform manualy
   it created Fagrate profile but wanted also update RDS, it finished with the following error.
   all infrastructure looks working, RDS Backup also works. We can continue with Flux setup  

│ Error: updating RDS DB Instance (aparflow-airflowfdna-metadata-smartsys-dev): operation error RDS: ModifyDBInstance, https response error StatusCode: 400, RequestID: 52c2abc7-eaf3-4a34-a0b8-c3f934942f6c, api error InvalidParameterValue: Your RDS instance aparflow-airflowfdna-metadata-smartsys-dev is associated with an AWS Backup resource with id arn:aws:backup:us-east-1:331013986936:recovery-point:continuous:db-qg3pg2ggvkybb7lwnhykpl3vza-a8864877. You can leave BackupRetentionPeriod blank, or you can specify it only with the current value 7. For more details, see the AWS Backup documentation.
│
│   with module.rds.aws_db_instance.metadatapgrds,
│   on ../../../../../modules/rds/rds.tf line 21, in resource "aws_db_instance" "metadatapgrds":
│   21: resource "aws_db_instance" "metadatapgrds" {
│
╵
Releasing state lock. This may take a few moments...

