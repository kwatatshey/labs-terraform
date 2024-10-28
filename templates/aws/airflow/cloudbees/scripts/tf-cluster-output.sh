echo "This is beginning of tf-cluster.sh script ---------------------"
echo "Terraform output running"
echo "PWD"
pwd
ORIG_DIR=$(pwd)
echo "ORIG_DIR=${ORIG_DIR}"
echo -e "TF_DIR=${TF_DIR}"
echo "cd {TF_DIR}"
cd ${TF_DIR}
echo "PWD"
pwd
echo "ls -al"
ls -al

echo "Storing output values"
echo "terraform output raw > OUTPUT_EFS_ACCESS_POINT_ID"
export CLUSTER_NAME="$(terraform output -raw cluster_name)"
echo -e "CLUSTER_NAME=${CLUSTER_NAME}"
echo "setting pipelineRuntime property: CLUSTER_NAME"
ectool setProperty "/myPipelineRuntime/CLUSTER_NAME" --value $CLUSTER_NAME

echo "This is end of tf-cluster.sh script -------------------------"