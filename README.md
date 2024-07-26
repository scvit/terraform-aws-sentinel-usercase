# Terraform AWS Sentinel Usecase

> Hardening security in AWS with Terraform Sentinel



## IAM Usecase

| Case                      | Condtions                                                    |
| ------------------------- | ------------------------------------------------------------ |
| 1. Password complexity    | Minimum password length > 8<br />Require at least one lowercase letter<br />Require at least one number<br />Require at least one non-alphanumeric character |
| 2. Password expiration    | Password expires in 90 day(s)                                |
| 3. Prevent password reuse | Remember last 2 password(s) and prevent reuse                |

1. [IAM/sentinel/check-iam-password-complexity.sentinel](./IAM/sentinel/check-iam-password-complexity.sentinel)

2. [IAM/sentinel/check-iam-password-expiration.sentinel](./IAM/sentinel/check-iam-password-expiration.sentinel)

3. [IAM/sentinel/check-iam-password-reuse-count.sentinel](./IAM/sentinel/check-iam-password-reuse-count.sentinel)



(IAM Password policy check - screenshot)

![Runs | policy_iam_password | great-stone-biz | HCP Terraform 2024-07-25 14-58-45](https://raw.githubusercontent.com/Great-Stone/images/master/picgo/Monosnap%20run-8rURPeHguShHZ6B5%20%7C%20Runs%20%7C%20policy_iam_password%20%7C%20great-stone-biz%20%7C%20HCP%20Terraform%202024-07-25%2014-58-45.png)





## Network Usecase (Not available)

| Case                                                         | Conditions                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Prevent assigning public IPs to private subnet resources     | Verify that the public IP assigned by Elastic IPs is granted to a service located in a private subnet |
| Prevent resources from connecting to both public and private subnets simultaneously | If a resource has more than one network interface (Elastic Network Interface) associated with it, verify that public and private subnets are not mixed |

When running Sentinel policies during the Terraform planning phase, it is difficult to fully verify the details of a resource before it is created. In particular, verifying whether the instance or network interface associated with an EIP is on a private subnet can be difficult for the following reasons

- Planning phase constraints: Sentinel policies perform verification when Terraform plans are applied, but the actual resource has not yet been created or deployed. This means that the instance or network interface to which the EIP will be attached may not have been created yet, or the subnet information for that instance may not be fully defined.

- Lack of subnet information: You might only know the subnet ID of the instance or network interface to which the EIP will connect, but the actual details of the subnet (for example, whether the subnet is private) might not be specified in the Terraform plan. In this case, validation can be difficult because the resources that need the subnet information do not yet exist.

Therefore, it is difficult to distinguish using only Sentinel, and it is possible to do so by intentionally assigning tags or naming rules.



## Compute Usecase

| Case                                | Conditions                                                   |
| ----------------------------------- | ------------------------------------------------------------ |
| 1. EBS Volume Encryption            | Verify EBS Volume Encryption Settings                        |
| 2. Restrict access to EBS snapshots | Set the Snapshot share permissions entry<br />Shared accounts must exist within the Permissions tab |

1. [Compute/sentinel/check-ebs-volume-encryption.sentinel](./Compute/sentinel/check-ebs-volume-encryption.sentinel)

2. [Compute/sentinel/check-snapshot-restrict-access.sentinel](./Compute/sentinel/check-snapshot-restrict-access.sentinel)



(Compute policy check - screenshot)

![Runs | policy_compute_condition | great-stone-biz | HCP Terraform 2024-07-26 09-10-26](https://raw.githubusercontent.com/Great-Stone/images/master/picgo/Monosnap%20run-6WjAkCfmJ9JjJsH3%20%7C%20Runs%20%7C%20policy_compute_condition%20%7C%20great-stone-biz%20%7C%20HCP%20Terraform%202024-07-26%2009-10-26.png)



## Lambda Usecase

| Case                                 | Conditions                                                |
| ------------------------------------ | --------------------------------------------------------- |
| 1. Lambda is configured inside a VPC | Check the VPC list in the Lambda Function's configuration |

1. [Lambda/sentinel/check-lambda-vpc-config.sentinel](./Lambda/sentinel/check-lambda-vpc-config.sentinel)



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



(EKS policy check - screenshot)

![Runs | policy_eks_security | great-stone-biz | HCP Terraform 2024-07-26 14-09-31](https://raw.githubusercontent.com/Great-Stone/images/master/picgo/Monosnap%20run-WmWfYxVT9LdcRcUD%20%7C%20Runs%20%7C%20policy_eks_security%20%7C%20great-stone-biz%20%7C%20HCP%20Terraform%202024-07-26%2014-09-31.png)



## ECR Usercase 

| Case                                                     | Conditions                                                   |
| -------------------------------------------------------- | ------------------------------------------------------------ |
| 1. Login when accessing ECR                              | Make sure ECR is set to Private                              |
| 2. Vulnerability scanning and remediation for ECR images | Check to enable vulnerability scanning for ECR images<br/>Review vulnerabilites results per image |
| 3. Encrypt for ECR images                                | Verify KMS encryption settings for ECR images                |

1. [ECR/sentinel/check-ecr-scanning.sentinecheck-ecr-private.sentinel](./ECR/sentinel/check-ecr-private.sentinel)

2. [ECR/sentinel/check-ecr-scanning.sentinel](./ECR/sentinel/check-ecr-scanning.sentinel)

3. [ECR/sentinel/check-ecr-encription.sentinel](./ECR/sentinel/check-ecr-encription.sentinel)



(ECR policy check - screenshot)

![Runs | policy_ecr_security | great-stone-biz | HCP Terraform 2024-07-26 15-11-20](https://raw.githubusercontent.com/Great-Stone/images/master/picgo/Monosnap%20run-unH5SuosJJXF7Z7x%20%7C%20Runs%20%7C%20policy_ecr_security%20%7C%20great-stone-biz%20%7C%20HCP%20Terraform%202024-07-26%2015-11-20.png)
