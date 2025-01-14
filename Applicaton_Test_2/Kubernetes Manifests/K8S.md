部署 Kubernetes 資源：
# 創建命名空間
kubectl apply -f namespaces.yaml

# 部署應用程序
kubectl apply -f app-deployment.yaml
kubectl apply -f app-service.yaml
kubectl apply -f app-ingress.yaml

# 部署 Jenkins
kubectl apply -f jenkins-sa.yaml
kubectl apply -f jenkins-deployment.yaml
kubectl apply -f jenkins-pvc.yaml
kubectl apply -f jenkins-service.yaml

# 配置 Jenkins 獲取初始密碼：
kubectl exec -it -n jenkins $(kubectl get pods -n jenkins -l app=jenkins -o jsonpath='{.items[0].metadata.name}') -- cat /var/jenkins_home/secrets/initialAdminPassword

# 設置以下憑證：
AWS 憑證
ECR 登錄憑證
Kubernetes 配置
配置 CI/CD Pipeline：

# 在 Jenkins 中創建新的 Pipeline 項目
配置 Git repository
添加 Jenkinsfile
設置 Webhook