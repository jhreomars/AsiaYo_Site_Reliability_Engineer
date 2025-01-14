# 試想有一服務架構圖如下
![Test_2](./Test_2.png)

作答要求：
● 請使用 terraform 架設如上述的 AWS Elastic Kubernetes Service (EKS)
的 cluster 服務。
● 請撰寫如圖中，適用於 k8s 的應用程式服務 manifest 設定檔。
● 設計時，請考量以高可用性為主。


讓系統性地說明架構配置：

1. **Terraform 配置架構**：

目錄結構：
```plaintext
.
├── main.tf               # 主配置文件
├── provider.tf           # AWS Provider配置
├── variables.tf          # 變量定義
├── outputs.tf            # 輸出定義
├── terraform.tfvars      # 變量值
└── modules/              # 模組目錄
    ├── networking/       # 網路模組
    ├── eks/              # EKS模組
    │   ├── main.tf       # EKS 叢集主配置
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── addons/      # 核心組件子模組
    │       ├── main.tf  # 核心組件配置
    │       ├── coredns.tf
    │       ├── vpc_cni.tf
    │       ├── kube_proxy.tf
    │       ├── metrics_server.tf
    │       ├── cluster_autoscaler.tf
    │       ├── container_insights.tf
    │       ├── variables.tf
    │       └── outputs.tf
    └── ecr/             # ECR模組
```

1. **Terraform 配置**：
A. **Networking 模組**：
- VPC 配置跨越三個可用區
- 每個可用區都有公有和私有子網
- 每個可用區配置獨立的 NAT Gateway
- 完整的路由表配置

B. **EKS 模組**：
- 配置1.27版本的 EKS 集群
- 節點組使用 t3.large 實例
- 配置自動擴展（3-5個節點）
- IAM 角色和權限配置
- 安全組配置

C. **ECR 模組**：
- 創建私有容器倉庫
- 配置生命週期政策
- 配置加密
- IAM 權限配置

2. **Kubernetes 配置**：
A. **應用部署**：
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: asiayo-app
spec:
  replicas: 3
  template:
    spec:
      containers:
        - name: asiayo-app
          resources:
            requests:
              cpu: "500m"
              memory: "512Mi"
            limits:
              cpu: "1000m"
              memory: "1Gi"
```

B. **服務配置**：
```yaml
apiVersion: v1
kind: Service
metadata:
  name: asiayo-app
spec:
  type: ClusterIP
  ports:
    - port: 80
```

C. **Ingress 配置**：
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: asiayo-app
spec:
  ingressClassName: nginx
```

3. **高可用性設計**：
A. **基礎設施層面**：
- VPC 跨三個可用區部署
- 每個可用區都有獨立的 NAT Gateway
- EKS 控制平面自動跨可用區部署
- 節點組跨可用區分布

B. **應用層面**：
- 使用 Deployment 確保至少3個副本
- Pod 反親和性避免單點故障
- 資源請求和限制確保性能
- 健康檢查和自動恢復

C. **網絡層面**：
- 使用 ALB/NLB 做負載均衡
- Ingress 控制器高可用配置
- 跨可用區的流量分配

4. **安全性考量**：
A. **網絡安全**：
- 私有子網部署工作負載
- 安全組嚴格控制訪問
- VPC 終端節點隔離服務

B. **身份和權限**：
- IAM 角色最小權限原則
- Pod 安全策略
- 網絡策略控制

C. **數據安全**：
- ECR 倉庫加密
- etcd 加密
- 傳輸層 TLS 加密

5. **維運考量**：
A. **監控和日誌**：
- EKS 控制平面日誌
- Container Insights
- CloudWatch Logs

B. **備份和恢復**：
- etcd 備份
- 持久卷備份策略

C. **擴展性**：
- 節點自動擴展
- Pod 水平自動擴展
- Cluster Autoscaler

