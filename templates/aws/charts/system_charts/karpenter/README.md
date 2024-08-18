### Things to Consider
- Karpenter uses another IAM Role for the node it creates. And that IAM Role needs to be authorized in K8s
- As aws-auth configmap is created during the eks cluster creation, this module has to modify the existing aws-auth configmap to authorize karpenter. 
- As a side affect, when you destroy the module, it also destroys the aws-auth configmap data causing the deletion of EKS Node role permissions
- You may use this module as a reference and deploy your target cluster accordingly
  - Either you can use access-entries instead of aws-auth in your eks cluster and modify karpenter module accordingly
  - Or Add Karpenter IAM Role to the aws-auth configmap during the cluster creation phase