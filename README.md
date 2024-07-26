# Terraform AWS Sentinel Usecase

> Hardening security in AWS with Terraform Sentinel



(IAM Password policy check - example)

![Monosnap run-8rURPeHguShHZ6B5 | Runs | policy_iam_password | great-stone-biz | HCP Terraform 2024-07-25 14-58-45](https://raw.githubusercontent.com/Great-Stone/images/master/picgo/Monosnap%20run-8rURPeHguShHZ6B5%20%7C%20Runs%20%7C%20policy_iam_password%20%7C%20great-stone-biz%20%7C%20HCP%20Terraform%202024-07-25%2014-58-45.png)



## IAM Usecase

| Case                   | Condtions                                                    |
| ---------------------- | ------------------------------------------------------------ |
| Password complexity    | Minimum password length > 8<br />Require at least one lowercase letter<br />Require at least one number<br />Require at least one non-alphanumeric character |
| Password expiration    | Password expires in 90 day(s)                                |
| Prevent password reuse | Remember last 2 password(s) and prevent reuse                |

- [IAM/sentinel/check-iam-password-complexity.sentinel](./IAM/sentinel/check-iam-password-complexity.sentinel)
- [IAM/sentinel/check-iam-password-expiration.sentinel](./IAM/sentinel/check-iam-password-expiration.sentinel)
- [IAM/sentinel/check-iam-password-reuse-count.sentinel](./IAM/sentinel/check-iam-password-reuse-count.sentinel)



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

| Case                             | Conditions                                                   |
| -------------------------------- | ------------------------------------------------------------ |
| EBS Volume Encryption            | Verify EBS Volume Encryption Settings                        |
| Restrict access to EBS snapshots | Set the Snapshot share permissions entry<br />Shared accounts must exist within the Permissions tab |

- [Compute/sentinel/check-ebs-volume-encryption.sentinel](./Compute/sentinel/check-ebs-volume-encryption.sentinel)
- [Compute/sentinel/check-snapshot-restrict-access.sentinel](./Compute/sentinel/check-snapshot-restrict-access.sentinel)



## Lambda Usecase

| Case                              | Conditions                                                |
| --------------------------------- | --------------------------------------------------------- |
| Lambda is configured inside a VPC | Check the VPC list in the Lambda Function's configuration |



## EKS Usecase

| Case                                                     | Conditions                                                   |
| -------------------------------------------------------- | ------------------------------------------------------------ |
| Encrypting Kubernetes Secrets                            | Verify Kubernetes Secrets encryption Enabled                 |
| Control Plane endpoint Private                           | Verify that API server endpoint access is Private            |
| Restrict access to the Control Plane API Server endpoint | Verify that no policies are allowed in the `Cluster security group`<br />Verify that no policies are allowed in `Additional security groups` |
| Node group is located on a private subnet                | Verify that subnets in Node Groups are set to private subnets<br />Verify that subnets in Node Groups do not have `igw-xxxxxxxx` specified in Route Table target<br />Check the Cluster security group disabled setting |



## ECR Usercase 

| Case                                                  | Conditions                                                   |
| ----------------------------------------------------- | ------------------------------------------------------------ |
| Login when accessing ECR                              | Make sure ECR is set to Private                              |
| Vulnerability scanning and remediation for ECR images | Check to enable vulnerability scanning for ECR images<br/>Review vulnerabilites results per image |
| Encrypt for ECR images                                | Verify KMS encryption settings for ECR images                |
