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