#VPC 
vpc_cidr             = "10.16.0.0/16"
instance_tenancy     = "default"
vpc_name             = "vpc"
env                  = "dev"
enable_dns_support   = true
enable_dns_hostnames = true

#IGW 
igw_name     = "VPC-IGW"
cluster-name = "eks-cluster"

# Subnets 

pub-subnet-count      = 3
pub-cidr-block        = ["10.16.0.0/20", "10.16.16.0/20", "10.16.32.0/20"]
pub-availability-zone = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
pub-sub-name          = "subnet-public"
pri-subnet-count      = 3
pri-cidr-block        = ["10.16.128.0/20", "10.16.144.0/20", "10.16.160.0/20"]
pri-availability-zone = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
pri-sub-name          = "subnet-private"

# Route Table
public-rt-name  = "public-route-table"
private-rt-name = "private-route-table"

nat_gw_name = "NAT-GW"
eip_name    = "VPC-Elastic-IP"

sg_name        = "eks-cluster-sg"
sg_description = "Security group for EKS cluster"

is_eks_role_enabled           = true
is_eks_nodegroup_role_enabled = true
aws_region                    = "ap-south-1"

is-eks-cluster-enabled  = true
kubernetes_version      = "1.30"
endpoint-private-access = true
endpoint-public-access  = false


instance_types = ["t3.large"]

desired_capacity = 1
min_capacity     = 1
max_capacity     = 5
