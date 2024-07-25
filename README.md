# Terraform AWS Sentinel Usecase

Hardening security in AWS with Terraform Sentinel

## IAM Usecase

| Case                   | Condtions                                                    |
| ---------------------- | ------------------------------------------------------------ |
| Password complexity    | Minimum password length > 8<br />Require at least one lowercase letter<br />Require at least one number<br />Require at least one non-alphanumeric character |
| Password expiration    | Password expires in 90 day(s)                                |
| Prevent password reuse | Remember last 2 password(s) and prevent reuse                |



## Network Usecase

| Case                                                         | Conditions                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Prevent assigning public IPs to private subnet resources     | Verify that the public IP assigned by Elastic IPs is granted to a service located in a private subnet |
| Prevent resources from connecting to both public and private subnets simultaneously | If a resource has more than one network interface (Elastic Network Interface) associated with it, verify that public and private subnets are not mixed |



## Compute Usecase

| Case                             | Conditions                                                   |
| -------------------------------- | ------------------------------------------------------------ |
| EBS Volume Encryption            | Verify EBS Volume Encryption Settings                        |
| Restrict access to EBS snapshots | Set the Snapshot share permissions entry<br />Shared accounts must exist within the Permissions tab |



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
