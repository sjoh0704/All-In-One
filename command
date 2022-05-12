< Terraform >
terraform apply -var-file=./credentials/credentials.tfvars


< kube config 갱신>
aws eks --region ap-northeast-2 update-kubeconfig --name my-eks-test


< tfenv >
.terraform-version에서 참조
tfenv list
tfenv use [version]