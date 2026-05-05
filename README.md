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
## 📦 IAM Policy Resource

Defines the IAM policy used by the Cluster Autoscaler.

```hcl
resource "aws_iam_policy" "autoscaler" {
  name   = "${var.cluster-name}-autoscaler"
  policy = data.aws_iam_policy_document.autoscaler.json
}
```
---
## 🔑 IAM Role Trust Policy (IRSA)

Defines the trust relationship using IAM Roles for Service Accounts (IRSA).
```hcl
data "aws_iam_policy_document" "autoscaler_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
  ```
---
## 🔍 Explanation
### 🎯 Service Account Restriction

* Grants access only to:
```bash  
    kube-system/cluster-autoscaler
```
* Prevents any other pod from assuming this role
---
### 🔐 OIDC Authentication
* Uses the EKS OIDC provider for secure authentication
* Eliminates the need for static AWS credentials
---
### 🛡️ Least Privilege Enforcement
* The sub condition ensures:
    * Only the specific Kubernetes service account can assume the role
* The aud condition ensures:
    * The token is intended for AWS STS (sts.amazonaws.com)
---
### 🏷️ IAM Role

Creates the IAM role used by the Cluster Autoscaler.

```hcl 
resource "aws_iam_role" "autoscaler" {
  name               = "${var.cluster-name}-autoscaler"
  assume_role_policy = data.aws_iam_policy_document.autoscaler_assume.json
}
```
---
### 🔗 Attach Policy to Role

Binds the IAM policy to the IAM role.

```hcl 
resource "aws_iam_role_policy_attachment" "autoscaler" {
  role       = aws_iam_role.autoscaler.name
  policy_arn = aws_iam_policy.autoscaler.arn
}
```
---
✅ Summary
| Component            | Purpose                                    |
|----------------------|--------------------------------------------|
| IAM Policy           | Defines autoscaler permissions             |
| Trust Policy (IRSA)  | Enables secure role assumption via OIDC    |
| IAM Role             | Identity used by Kubernetes service account|
| Policy Attachment    | Grants permissions to the role             |

---
## ⚙️ Kubernetes Service Account Annotation

Bind the IAM role to the Cluster Autoscaler pod using **IRSA annotation**:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: cluster-autoscaler
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: <IAM_ROLE_ARN>
```
---
## 🔍 IAM Role Association with Kubernetes Service Account

This setup enables secure communication between a Kubernetes workload and AWS services using **IAM Roles for Service Accounts (IRSA)**.

### 📌 What This Does

- Associates a **Kubernetes Service Account** with an **AWS IAM Role**
- Allows pods (e.g., Cluster Autoscaler) to securely access AWS APIs

### ⚙️ How It Works

1. **OIDC Authentication**
   - The Kubernetes Service Account is linked to an IAM Role via OIDC
   - The pod receives a projected service account token

2. **STS Assume Role**
   - The pod uses the token to call AWS STS (`AssumeRoleWithWebIdentity`)
   - Temporary credentials are issued dynamically

3. **Secure Access**
   - The pod uses these temporary credentials to interact with AWS services

### ✅ Key Benefits

- ❌ No hardcoded AWS credentials inside pods
- 🔐 Fine-grained IAM permissions per workload
- 🔄 Automatic credential rotation via STS
- 🚀 Follows AWS security best practices

### 📦 Example Use Case

Cluster Autoscaler uses this setup to:
- Discover Auto Scaling Groups
- Scale nodes up/down dynamically

---

### 🧠 Why This Matters

If you're still injecting AWS keys into pods, that's not just outdated — it's risky and lazy engineering.

IRSA is the **only production-grade approach** for:
- EKS security
- Least privilege access
- Auditable IAM control

---

### 🔗 Prerequisites

- EKS cluster with **OIDC provider enabled**
- IAM Role with required policies
- Service Account annotated with IAM Role ARN

---

### 📌 Summary

| Component              | Role                                      |
|-----------------------|-------------------------------------------|
| Service Account       | Identity inside Kubernetes                |
| OIDC Provider         | Trust bridge between EKS and AWS IAM      |
| IAM Role              | Defines permissions                       |
| STS                   | Issues temporary credentials              |

---
## ✅ Validation

Follow these steps to confirm that **IRSA + Cluster Autoscaler** is working correctly.

---
### 1️⃣ Verify Service Account Annotation

```bash
kubectl describe sa cluster-autoscaler -n kube-system
```
### 👉 Expected Output

eks.amazonaws.com/role-arn 
annotation is present Correct IAM Role ARN is attached
---

### 🔗 Attach IAM Role to Cluster Autoscaler (IRSA)

To enable Cluster Autoscaler to access AWS APIs securely, attach an IAM role to its Kubernetes Service Account using IRSA.

---

## ✅ Option 1 — Patch Existing ServiceAccount (Recommended)

Use the following command to add or update the IAM role annotation:

```bash
kubectl annotate serviceaccount cluster-autoscaler \
  -n kube-system \
  eks.amazonaws.com/role-arn=arn:aws:iam::104824081961:role/eks-cluster-autoscaler \
  --overwrite
```
## ✅ Option 2 — Declarative YAML (Preferred for GitOps)

Define the ServiceAccount with annotation:
```bash 
apiVersion: v1
kind: ServiceAccount
metadata:
  name: cluster-autoscaler
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::104824081961:role/eks-cluster-autoscaler
```
Apply the configuration:

```bash 
kubectl apply -f sa.yaml
```
---

## 🔍 Verification

Ensure the annotation is applied correctly:

```bash 
kubectl describe sa cluster-autoscaler -n kube-system
```
Expected output:

Annotations:
```bash 
  eks.amazonaws.com/role-arn: arn:aws:iam::104824081961:role/eks-cluster-autoscaler
```
⚠️ Notes

* Ensure IAM trust policy allows:
```bash 
system:serviceaccount:kube-system:cluster-autoscaler
```
* Restart the autoscaler pod if required:
```bash 
kubectl delete pod -n kube-system -l app=cluster-autoscaler
```

### 🎯 Key Takeaway
This step securely connects Kubernetes with AWS:

* No static credentials
* Fine-grained IAM permissions
* Required for Cluster Autoscaler to function
---