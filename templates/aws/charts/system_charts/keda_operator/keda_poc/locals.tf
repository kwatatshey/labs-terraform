locals {
  consumer_yaml_path              = "${path.module}/yamls/py_consumer.yaml"
  producer_yaml_path              = "${path.module}/yamls/py_producer.yaml"
  scaled_app_yaml_path            = "${path.module}/yamls/scaled_app.yaml"
  sqs_scaled_object_yaml_path     = "${path.module}/yamls/sqs_scaledobj_definition.yaml"
  keda_service_accounts_yaml_path = "${path.module}/yamls/service_account.yaml"

  consumer_yaml = templatefile(local.consumer_yaml_path, {
    consumer_deployment_name      = var.consumer_deployment_name
    namespace                     = var.namespace
    py_service_account_name       = var.py_service_account_name
    sqs_queue_url                 = aws_sqs_queue.keda_queue.url
    sqs_queue_name                = aws_sqs_queue.keda_queue.name
  })

  producer_yaml = templatefile(local.producer_yaml_path, {
    producer_deployment_name      = var.producer_deployment_name
    namespace                     = var.namespace
    py_service_account_name       = var.py_service_account_name
    sqs_queue_url                 = aws_sqs_queue.keda_queue.url
    sqs_queue_name                = aws_sqs_queue.keda_queue.name
  })

  sqs_scaled_object_yaml = templatefile(local.sqs_scaled_object_yaml_path , {
    namespace              = var.namespace
    app_deployment_name    = var.app_deployment_name
    sqs_queue_length       = var.sqs_queue_length
    polling_interval       = var.polling_interval
    cooldown_period        = var.cooldown_period
    min_replica_count      = var.min_replica_count
    region                 = var.region
    max_replica_count      = var.max_replica_count
    sqs_queue_url          = aws_sqs_queue.keda_queue.url
  })

  scaled_app_yaml = templatefile(local.scaled_app_yaml_path, {
    namespace           = var.namespace
    app_deployment_name = var.app_deployment_name
  })

  keda_service_accounts_yaml = templatefile(local.keda_service_accounts_yaml_path, {
    keda_role_arn             = module.keda_irsa_role.iam_role_arn
    py_role_arn               = module.py_irsa_role.iam_role_arn
    namespace                 = var.namespace
    py_service_account_name   = var.py_service_account_name
    keda_service_account_name = var.keda_service_account_name

  })
}
