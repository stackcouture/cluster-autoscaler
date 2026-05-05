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