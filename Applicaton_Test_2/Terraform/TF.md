# 初始化專案
terraform init

# 建立工作環境
terraform workspace new prod

# 檢視變更計畫
terraform plan

# 套用變更
terraform apply

# 專案結構
.
├── main.tf               # 主入口點
├── provider.tf           # 提供者配置
├── variables.tf          # 變量定義
├── outputs.tf            # 輸出定義
├── terraform.tfvars      # 變量值
└── modules/
    ├── networking/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── eks/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── ecr/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf

