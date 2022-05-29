# All-In-One (개발 중)

## 개요
- AWS 환경에서 managed K8S를 구축하고, MSA 구성부터 배포까지 모든 것들을 다 해보기 위한 프로젝트입니다. 
- Terraform을 통해 EKS Cluster를 구축하고, 모든 App을 자동으로 배포합니다.
- EKS Cluster로 배포되는 MSA Shop은 Gitops 방식의 CI/CD로 배포됩니다.
- 카나리 배포 자동화 
- 계속해서 추가 예정 입니다...

<br/>

(X) 표시는 아직 구현 전

<br/>

## Components
### 1. AWS Techs
- EKS
- ECR
- Cloud Watch
- ALB
- EFS(X)
- 

<br/>

### 2. Devops Techs
- Terraform 
- GitAction
- ArgoCD
- Helm
- istio(X)
- flagger(X)
- 

<br/>

### 3. Application Techs 
- Nodejs 
- React
- Django
- Nginx
- Mysql
- MongoDB

<br/>

### 4. ETC
- OIDC provider

<br/>


## 배포할 애플리케이션 - MSA Shop

|Service name| Role | 사용 DB | 
|---|---|---|
| [Front](https://github.com/sjoh0704/All-In-One-Front) | 사용자 UI | X |
| [Cart](https://github.com/sjoh0704/All-In-One-Cart) | 상품을 담을 수 있는 카트 | MongoDB |
| [User](https://github.com/sjoh0704/All-In-One-User) | 로그인/회원가입 및 사용자 정보관리 | MySQL |
| [Product](https://github.com/sjoh0704/All-In-One-Product) | 상품 등록 및 관리 | MySQL |
| [Rating](https://github.com/sjoh0704/All-In-One-Rating) | 사용자 평점 시스템 | MongoDB |
| [Order](https://github.com/sjoh0704/All-In-One-Order) | 상품 주문 | MySQL |

<br/>

![image](https://user-images.githubusercontent.com/66519046/170871601-53ca73dd-c345-416e-87aa-d91946199b5e.png)

<br/>

## 주요 기능 설명 
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


![image](https://user-images.githubusercontent.com/66519046/170867231-e1cb615b-a932-4576-8f46-715c5b04191f.png)

<br/>


### 2. MSA Shop을 이루는 각각의 서비스에 대해서 gitops 기반 CI/CD 파이프라인 구축
- 다음과 같은 flow를 통해서 App이 빌드되고 배포됩니다.
    - 개발자는 App repository에 tag를 push
    - GitAction은 event를 감지하고 동작
    - Dockerfile build
    - OIDC provider로부터 ID 토큰 발급
    - AWS IAM에게 ID 토큰 검증 후, Access 토큰 발급
    - AWS IAM으로부터 ECR Push IAM role에 대한 임시 자격 증명 발급
    - ECR에 빌드된 이미지 push
    - manifest repo에 새로운 이미지에 대한 정보 업데이트
    - EKS Cluster에 배포된 ArgoCD는 manifest repo와 sync
    - ArgoCD를 통해서 새로운 이미지의 App을 pod로 배포 

![image](https://user-images.githubusercontent.com/66519046/170866388-b4246524-b86d-460d-b0bf-eb40da51b05c.png)


<br/>


## 이외의 기능
### 3. EKS OIDC provider를 구성하여 AWS 서비스를 사용하는 pod에게 최소한의 policy를 가진 IAM role을 부여합니다. 
### 4. Cloud watch agent를 이용한 메트릭 수집 후, Cloud Watch로 전송합니다.
### 5.  