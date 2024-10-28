# Values of mandatory Merck tags
common_tags = {
  Environment        = "Production"
  Application        = "aparflow"
  Costcenter         = "10004416"
  Division           = "CTO Org"
  DataClassification = "Proprietary"
  Consumer           = "airflow_eng@merck.com"
  Service            = "aparflow-production"
}

prometheus_agent_roles = [
  "arn:aws:iam::528750871903:role/fdsdmlab-airflow-prometheus-role",
  "arn:aws:iam::331013986936:role/aparflow-airflow-eks-prometheus-role-us-east-1",
  "arn:aws:iam::331013986936:role/aparflow-airflow-eks-prometheus-role-eu-west-1",
  "arn:aws:iam::331013986936:role/aparflow-airflow-eks-prometheus-role-ap-southeast-1",
  "arn:aws:iam::015811401862:role/aparflow-airflow-eks-prometheus-role-us-east-1",
  "arn:aws:iam::015811401862:role/aparflow-airflow-eks-prometheus-role-eu-west-1",
  "arn:aws:iam::015811401862:role/aparflow-airflow-eks-prometheus-role-ap-southeast-1",
  "arn:aws:iam::127753455852:role/aparflow-airflow-eks-prometheus-role-us-east-1",
  "arn:aws:iam::127753455852:role/aparflow-airflow-eks-prometheus-role-eu-west-1",
  "arn:aws:iam::127753455852:role/aparflow-airflow-eks-prometheus-role-ap-southeast-1",
  "arn:aws:iam::806735670197:role/aparflow-airflow-eks-prometheus-role-us-east-1",
  "arn:aws:iam::806735670197:role/aparflow-airflow-eks-prometheus-role-eu-west-1",
  "arn:aws:iam::806735670197:role/aparflow-airflow-eks-prometheus-role-ap-southeast-1"
]

lambda_moogsoft_policy_arns = [
  "arn:aws:iam::806735670197:policy/service-role/AWSLambdaBasicExecutionRole-1cb6c988-445c-4d6f-a813-2359f4ababb0",
  "arn:aws:iam::806735670197:policy/service-role/AWSLambdaVPCAccessExecutionRole-6d594a4a-58c9-4221-8709-c27209124f2e",
  "arn:aws:iam::806735670197:policy/moogsoft-secrets-manager",
]

sns_subscription_email_list = []

subnet_ids         = ["subnet-0af3858aec0585024"]
security_group_ids = ["sg-02ef8d708b1687dbb"]

custom_policy_statement = [
  {
    "Effect" : "Allow",
    "Action" : "secretsmanager:GetSecretValue",
    "Resource" : "arn:aws:secretsmanager:us-east-1:806735670197:secret:aparflow/airflowfdna/moogsoft-mha8bx"
  }
]

lambda_moogsoft_additional_tags = {
  DTALERT = "disable"
}
