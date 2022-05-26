# All-In-One (개발 중)

## 개요
- Terraform을 통해 EKS Cluster를 구축하고, 모든 App을 자동으로 배포합니다.
- EKS Cluster로 배포되는 마이크로 서비스들은 Gitops 방식의 CI/CD로 배포됩니다.
- 무중단 카나리 배포
- 계속해서 추가 예정...

<br/>

(X) 표시는 아직 구현 전

<br/>

## Components
### 1. AWS Techs
- EKS
- ECR
- Cloud Watch
- EFS(X)
- ALB
- ... 

<br/>

### 2. Devops Techs
- Terraform 
- GitAction
- ArgoCD
- Helm
- istio(X)
- flagger(X)
- ...

<br/>

### 3. Application Techs 
- Nodejs 
- React
- Django
- Nginx
- Mysql
- MongoDB
- ... 

<br/>

### 4. ETC
- OIDC 

<br/>


## MSA Shop Application
|Service name| Role | 사용 DB | 
|---|---|---|
| [Front](https://github.com/sjoh0704/All-In-One-Front) | 사용자 UI | X |
| [Cart](https://github.com/sjoh0704/All-In-One-Cart) | 상품을 담을 수 있는 카트 | MongoDB |
| [User](https://github.com/sjoh0704/All-In-One-User) | 로그인/회원가입 및 사용자 정보관리 | MySQL |
| [Product](https://github.com/sjoh0704/All-In-One-Product) | 상품 등록 및 관리 | MySQL |
| [Rating](https://github.com/sjoh0704/All-In-One-Rating) | 사용자 평점 시스템 | MongoDB |
| [Order](https://github.com/sjoh0704/All-In-One-Order) | 상품 주문 | MySQL |

<br/>

<br/>

## 기능 설명 
### 1. Terraform을 이용한 EKS cluster 구성 및 chart 배포
- Terraform apply시 EKS 클러스터를 구축합니다.
- 클러스터 구축 완료 후, 인프라 구성에 필요한 helm chart 및 add-on을 설치합니다. 
- 설치되는 chart 및 add-on
    - ArgoCD
    - aws-cloud-watch-metrics
    - aws-load-balancer-controller
    - coredns
    - vpc-cni
    - kube-proxy

<br/>

### 2. MSA Shop을 이루는 각각의 서비스에 대해서 gitops 기반 CI/CD 파이프라인 구축
- 다음과 같은 flow를 통해서 App이 빌드되고 배포됩니다.
    - 개발자는 git repository에 tag를 push
    - GitAction은 event를 감지하고 동작
    - Dockerfile build
    - OIDC provider로부터 AWS IAM에 대한 Access 토큰 발급
    - AWS IAM로부터 ECR Push에 대한 임시 자격 증명 발급
    - ECR에 빌드된 이미지 push
    - helm chart manifest update
    - EKS Cluster에 배포된 ArgoCD는 repository와 sync
    - 새로운 이미지의 App 배포 완료 

<br/>

### 3. EKS OIDC provider를 구성하여 AWS 서비스를 사용하는 pod에게 최소한의 policy를 가진 IAM role을 부여합니다. 
