# 🚀 Kubernetes Cluster Autoscaler (Production-Grade Implementation)

## 📌 Overview

This project demonstrates a **production-ready implementation of Kubernetes Cluster Autoscaler** on AWS EKS, including:

- Automatic node scaling based on workload demand
- Secure IAM integration using IRSA
- Real-world debugging and observability
- Cost optimization through intelligent scale-down

---

## 🧠 Why This Project Matters

✔ Understand the **scheduler behavior**  
✔ Debug **real scaling failures**  
✔ Design **cost-efficient infrastructure**

---

## 🎯 Architecture

```text
                 +----------------------+
                 |   Kubernetes API     |
                 +----------+-----------+
                            |
                            v
                 +----------------------+
                 | Cluster Autoscaler   |
                 +----------+-----------+
                            |
                            v
          +--------------------------------------+
          | AWS Auto Scaling Group (Node Group)  |
          +----------------+---------------------+
                           |
                           v
                  +------------------+
                  | EC2 Worker Nodes |
                  +------------------+
```
---
### Flow Explanation

1. Pods are created in Kubernetes
2. Scheduler tries to place them on nodes
3. If unschedulable → marked as `Pending`
4. Cluster Autoscaler detects this
5. Calls AWS Auto Scaling Group (ASG)
6. New EC2 node is launched
7. Node joins cluster
8. Pod gets scheduled

---

## 🏗️ Architecture Components

- **Kubernetes API Server** – control plane
- **Cluster Autoscaler** – decision engine
- **AWS Auto Scaling Group (ASG)** – node provisioning
- **EC2 Worker Nodes** – compute layer
- **Pods** – workload drivers

---
## 🔐 IAM Setup for Cluster Autoscaler (IRSA)

This section configures secure AWS access for Cluster Autoscaler using **IAM Roles for Service Accounts (IRSA)**.

---

## 📄 IAM Policy (Permissions)

```hcl
data "aws_iam_policy_document" "autoscaler" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeTags",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions"
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "eks:DescribeNodegroup",
    ]

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/${local.cluster_name}"
      values   = ["owned"]
    }
  }
}
```
## Explanation

### 1. Read-Only Permissions
The first statement grants **read-only access** to AWS resources.  
This is required for the autoscaler to **discover and understand the current infrastructure state**, including:

- Auto Scaling Groups
- EC2 instance types
- Launch configurations
- Scaling activities

---

### 2. Scaling Permissions
The second statement provides permissions to **modify infrastructure capacity**, allowing the autoscaler to:

- Increase node count when demand rises
- Decrease node count when resources are underutilized

---

### 3. Security Condition (Critical)

A condition block is applied to restrict scaling actions based on resource tags.

#### Purpose:
- Ensures actions are performed **only on node groups belonging to the specific cluster**
- Prevents accidental or unauthorized scaling of resources in **other clusters**

#### Benefit:
- Acts as a **critical security control**
- Avoids **cross-cluster impact**
- Enforces **least privilege principle**

---

## ✅ Summary

| Component            | Purpose                                   |
|---------------------|--------------------------------------------|
| Read Permissions     | Discover infrastructure state             |
| Scaling Permissions  | Adjust cluster capacity                   |
| Condition Block      | Enforce cluster-level isolation & security|
---