# Terraform AWS Sentinel Usecase

> Hardening security in AWS with Terraform Sentinel



**CAUTION** - `provider.tf`의 `terraform` stanza 확인 



## IAM Usecase

| Case                      | Condtions                                                    |
| ------------------------- | ------------------------------------------------------------ |
| 1. Password complexity    | Minimum password length > 8 <br/>Require at least one lowercase letter <br/>Require at least one number<br/>Require at least one non-alphanumeric character |
| 2. Password expiration    | Password expires in 90 day(s)                                |
| 3. Prevent password reuse | Remember last 2 password(s) and prevent reuse                |

1. [IAM/sentinel/check-iam-password-complexity.sentinel](./IAM/sentinel/check-iam-password-complexity.sentinel)

2. [IAM/sentinel/check-iam-password-expiration.sentinel](./IAM/sentinel/check-iam-password-expiration.sentinel)

3. [IAM/sentinel/check-iam-password-reuse-count.sentinel](./IAM/sentinel/check-iam-password-reuse-count.sentinel)



(KR)

| Case                    | Condtions                                                    |
| ----------------------- | ------------------------------------------------------------ |
| 1. 패스워드 복잡도      | 패스워드 최소 길이 > 8<br />패스워드 소문자 필수 포함<br />패스워드 숫자 필수 포함<br />패스워드 특수문자 포함 |
| 2. 패스워드 만료기한    | 패스워드 만료기한 90일                                       |
| 3. 패스워드 재사용 방지 | 이전 2개 패스워드 재사용 금지                                |



(IAM Password policy check - screenshot)

![Runs | policy_iam_password | great-stone-biz | HCP Terraform 2024-07-25 14-58-45](https://raw.githubusercontent.com/Great-Stone/images/master/picgo/Monosnap%20run-8rURPeHguShHZ6B5%20%7C%20Runs%20%7C%20policy_iam_password%20%7C%20great-stone-biz%20%7C%20HCP%20Terraform%202024-07-25%2014-58-45.png)





## Network Usecase (Not available)

| Case                                                         | Conditions                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Prevent assigning public IPs to private subnet resources     | IP Verify that the public IP assigned by Elastic IPs is granted to a service located in a private subnet |
| Prevent resources from connecting to both public and private subnets simultaneously | If a resource has more than one network interface (Elastic Network Interface) associated with it, verify that public and private subnets are not mixed |

When running Sentinel policies during the Terraform planning phase, it is difficult to fully verify the details of a resource before it is created. In particular, verifying whether the instance or network interface associated with an EIP is on a private subnet can be difficult for the following reasons

- Planning phase constraints: Sentinel policies perform verification when Terraform plans are applied, but the actual resource has not yet been created or deployed. This means that the instance or network interface to which the EIP will be attached may not have been created yet, or the subnet information for that instance may not be fully defined.

- Lack of subnet information: You might only know the subnet ID of the instance or network interface to which the EIP will connect, but the actual details of the subnet (for example, whether the subnet is private) might not be specified in the Terraform plan. In this case, validation can be difficult because the resources that need the subnet information do not yet exist.

Therefore, it is difficult to distinguish using only Sentinel, and it is possible to do so by intentionally assigning tags or naming rules.


(KR) 

| Case                                              | Conditions                                                   |
| ------------------------------------------------- | ------------------------------------------------------------ |
| 프라이빗 서브넷 리소스에 퍼블릭 IP 부여 방지      | EIP로 할당된 퍼블릭 IP가 프라이빗 서브넷의 리소스에 부여됬는지 확인 |
| 퍼블릭, 프라이빗 서브넷에 동시에 리소스 연결 방지 | 리소스가 2개 이상의 ENI가 할당되어 있을 때, 퍼블릭과 프라이빗 서브넷이 같이 부여되지 않도록 검증 |



Sentinel 정책이 Terraform Plan 단계에서 심사할 때, 리소스가 만들어지기 전에 검증하기 어렵습니다. 특히 아래와 같은 이유로 프라이빗 서브넷 상에 EIP와 연결된 인스턴스나 ENI를 파악하기 어렵습니다.

* Plan 단계 제약 : Sentinel 정책은 리소스가 생성 및 배포되기 이전, 즉 Plan단계 상황에서 정책을 심사합니다. 즉, 리소스가 생성되기 이전에 인스턴스나 ENI가 EIP가 할당되어 있는지 혹은 서브넷 정보가 완전히 정의되어 있는지 파악할 수 없습니다.
* 서브넷 정보 부족 : Plan 단계에서 EIP가 할당된 인스턴스나 ENI의 서브넷 ID만 알 수 있으며, 실제 서브넷의 상세한 정보 ( 프라이빗 서브넷  여부)를 특정할 수 없습니다. 이러한 경우, 서브넷 정보가 아직 존재하지 않기 때문에 검증이 어려울 수 있습니다.





## Compute Usecase 

| Case                                | Conditions                                                   |
| ----------------------------------- | ------------------------------------------------------------ |
| 1. EBS Volume Encryption            | Verify EBS Volume Encryption Settings                        |
| 2. Restrict access to EBS snapshots | Set the Snapshot share permissions entry <br/>Shared accounts must exist within the Permissions tab |

1. [Compute/sentinel/check-ebs-volume-encryption.sentinel](./Compute/sentinel/check-ebs-volume-encryption.sentinel)

2. [Compute/sentinel/check-snapshot-restrict-access.sentinel](./Compute/sentinel/check-snapshot-restrict-access.sentinel)



(KR)

| Case                    | Conditions                                                   |
| ----------------------- | ------------------------------------------------------------ |
| 1. EBS 볼륨 암호화      | EBS 볼륨 암호화 세팅 확인                                    |
| 2. EBS 스냅샷 접근 제한 | 스냅샷 공유 권한 설정 <br />스냅샷에 대한 권한을 공유 계정에 부여 |



(Compute policy check - screenshot)

![Runs | policy_compute_condition | great-stone-biz | HCP Terraform 2024-07-26 09-10-26](https://raw.githubusercontent.com/Great-Stone/images/master/picgo/Monosnap%20run-6WjAkCfmJ9JjJsH3%20%7C%20Runs%20%7C%20policy_compute_condition%20%7C%20great-stone-biz%20%7C%20HCP%20Terraform%202024-07-26%2009-10-26.png)



## Lambda Usecase

| Case                                 | Conditions                                                |
| ------------------------------------ | --------------------------------------------------------- |
| 1. Lambda is configured inside a VPC | Check the VPC list in the Lambda Function's configuration |

1. [Lambda/sentinel/check-lambda-vpc-config.sentinel](./Lambda/sentinel/check-lambda-vpc-config.sentinel)



(KR)

| Case                   | Conditions                              |
| ---------------------- | --------------------------------------- |
| 1. VPC내에 Lambda 설정 | Lambda 함수 내에 VPC 설정이 있는지 확인 |



(Lambda policy check - screenshot)

![Runs | policy_lambda_vpc | great-stone-biz | HCP Terraform 2024-07-26 10-47-32](https://raw.githubusercontent.com/Great-Stone/images/master/picgo/Monosnap%20run-WqpdjhQVbdBN6E4Y%20%7C%20Runs%20%7C%20policy_lambda_vpc%20%7C%20great-stone-biz%20%7C%20HCP%20Terraform%202024-07-26%2010-47-32.png)



## EKS Usecase

| Case                                                        | Conditions                                                   |
| ----------------------------------------------------------- | ------------------------------------------------------------ |
| 1. Encrypting Kubernetes Secrets                            | Verify Kubernetes Secrets encryption Enabled                 |
| 2. Control Plane endpoint Private                           | Verify that API server endpoint access is Private            |
| 3. Restrict access to the Control Plane API Server endpoint | Verify that no policies are allowed in the `Cluster security group`<br />Verify that no policies are allowed in `Additional security groups` |
| 4. Node group is located on a private subnet                | Verify that subnets in Node Groups are set to private subnets<br />Verify that subnets in Node Groups do not have `igw-xxxxxxxx` specified in Route Table target<br />Check the Cluster security group disabled setting |

When running Sentinel policies during the terraform planning phase, it is difficult to fully verify the details of a resource before it is created. Verifying that a network interface is on a private subnet can be difficult for the following reasons.

- Planning phase constraints: Sentinel policies perform verification when a Terraform plan has been applied but the actual resource has not yet been created or deployed. This means that the network interfaces that will connect to the EKS node group might not have been created yet, or the subnet information for that instance might not be fully defined.

1. [EKS/sentinel/check-eks-secrets-encryption.sentinel](./EKS/sentinel/check-eks-secrets-encryption.sentinel)

2. [EKS/sentinel/check-eks-endpoint-private.sentinel](./EKS/sentinel/check-eks-endpoint-private.sentinel)

3. [EKS/sentinel/check-eks-security-group.sentinel](./EKS/sentinel/check-eks-security-group.sentinel)

4. [EKS/sentinel/check-eks-node-group-located-private.sentinel](./EKS/sentinel/check-eks-node-group-located-private.sentinel)



(KR)

| Case                                           | Conditions                                                   |
| ---------------------------------------------- | ------------------------------------------------------------ |
| 1. Kubernetes Secret 암호화                    | Kubernetes Secret 암호화 여부 확인                           |
| 2. Private Control Plane 엔드포인트            | API 서버 엔드포인트 프라이빗 여부 확인                       |
| 3. Control Plane API 서버 엔드포인트 접근 제한 | `Cluster security group` 및 `Additional security groups`에 정책 미허용 확인 |
| 4. 노드 그룹 프라이빗 서브넷 존재 여부         | 프라이빗 서브넷에 노드그룹 존재 여부 검증  <br />노드그룹 서브넷 라우팅 테이블에 `igw-xxxxxxxx`를 가지지 못하도록 검증 <br />클러스터 보안그룹 비활성화 확인 |

리소스 생성 이전에 리소스에 대한 상세 정보를 파악하기 어렵습니다. 아래와 같은 이유로 프라이빗 서브넷에 네트워크 인터페이스가 있는지 검증하기 어렵습니다.

* Plan 단계 제약 : EKS 노드 그룹에 연결된 네트워크 인터페이스가 아직 생성되지 않았거나 서브넷 정보가 완전히 정의되지 않은 리소스 생성 이전인 Plan 단계에서 Sentinel 정책이 심사를 완료합니다. 



(EKS policy check - screenshot)

![Runs | policy_eks_security | great-stone-biz | HCP Terraform 2024-07-26 14-09-31](https://raw.githubusercontent.com/Great-Stone/images/master/picgo/Monosnap%20run-WmWfYxVT9LdcRcUD%20%7C%20Runs%20%7C%20policy_eks_security%20%7C%20great-stone-biz%20%7C%20HCP%20Terraform%202024-07-26%2014-09-31.png)



## ECR Usercase 

| Case                                                     | Conditions                                                   |
| -------------------------------------------------------- | ------------------------------------------------------------ |
| 1. Login when accessing ECR                              | Make sure ECR is set to Private                              |
| 2. Vulnerability scanning and remediation for ECR images | Check to enable vulnerability scanning for ECR images<br/>Review vulnerabilites results per image |
| 3. Encrypt for ECR images                                | Verify KMS encryption settings                               |

1. [ECR/sentinel/check-ecr-scanning.sentinecheck-ecr-private.sentinel](./ECR/sentinel/check-ecr-private.sentinel)

2. [ECR/sentinel/check-ecr-scanning.sentinel](./ECR/sentinel/check-ecr-scanning.sentinel)

3. [ECR/sentinel/check-ecr-encription.sentinel](./ECR/sentinel/check-ecr-encription.sentinel)



(KR)

| Case                      | Conditions                                                   |
| ------------------------- | ------------------------------------------------------------ |
| 1. ECR에 접근 시 로그인   | ECR 프라이빗 여부 확인                                       |
| 2. ECR 이미지 취약점 검토 | ECR 이미지 취약점 스캐닝 활성화 <br/>이미지 별 취약점 결과 리뷰 |
| 3. ECR 이미지 암호화      | ECR 이미지에 KMS 암호화 여부                                 |



(ECR policy check - screenshot)

![Runs | policy_ecr_security | great-stone-biz | HCP Terraform 2024-07-26 15-11-20](https://raw.githubusercontent.com/Great-Stone/images/master/picgo/Monosnap%20run-unH5SuosJJXF7Z7x%20%7C%20Runs%20%7C%20policy_ecr_security%20%7C%20great-stone-biz%20%7C%20HCP%20Terraform%202024-07-26%2015-11-20.png)
