# 系統架構與維運面試題目解答

## 題目一：高流量活動網頁專案架構規劃
### 確保服務正常運作的策略

針對預期流量暴增百倍的情況，建議採取以下措施：

#### 基礎架構層面
- 使用彈性伸縮（Auto Scaling）機制，根據負載自動調整服務器數量
- 採用負載平衡器（Load Balancer）分散流量
- 實施 CDN 服務，降低原始服務器負載
- 設置緩存層（如 Redis、Memcached），減少資料庫查詢

#### 消息處理層面
- 使用 Kafka 實現異步處理機制
- 通過消息佇列緩衝突發流量
- 實現事件驅動架構，提高系統解耦
- 建立消息持久化機制，確保資料不丟失
- 實施消息分區策略，提高處理效能

#### 資料庫層面
- 實施讀寫分離架構
- 建立資料庫副本，分散查詢壓力
- 優化資料庫索引和查詢語句
- 實施資料庫連接池管理

#### 安全防護層面 - 異常存取防禦
- SQL Injection 防護
  - 使用參數化查詢（Prepared Statements）
  - 實施輸入驗證和消毒（Input Validation & Sanitization）
  - 採用 ORM 框架，避免直接 SQL 查詢
  - 限制資料庫用戶權限

- 緩衝區溢位攻擊防護
  - 實施記憶體邊界檢查
  - 採用安全的記憶體管理機制
  - 定期更新系統和函式庫版本

- 爬蟲防禦機制
  - 使用 CAPTCHA/reCAPTCHA 機制
  - 監控並限制異常訪問模式
  - 實施 IP 行為分析和存取限制
  - 設置 API 呼叫頻率限制

- 行為分析與防護
  - 建立用戶行為基線
  - 檢測異常訪問模式
  - 實施漸進式的限制措施
  - 建立自動化的封鎖機制
- 部署 WAF（Web Application Firewall）防護
  - 防止 SQL 注入、XSS、CSRF 等常見攻擊
  - 設置請求速率限制（Rate Limiting）
  - 配置 IP 黑名單機制
- 實施 DDoS 防護措施
  - 使用 AWS Shield 或 Cloudflare 等 DDoS 防護服務
  - 配置流量清洗機制
  - 建立異常流量監控和自動封鎖機制
- 應用程式安全
  - 實施 API 認證和授權機制
  - 加密敏感數據傳輸（SSL/TLS）
  - 設置請求來源驗證（CORS 策略）
- 安全監控與響應
  - 建立安全事件監控系統
  - 制定安全事件應急響應流程
  - 定期進行安全漏洞掃描

#### 監控與應急
- 建立完整的監控系統，包括 CPU、記憶體、網路等指標
- 設置適當的告警閾值
- 準備應急方案和回滾機制
- 進行壓力測試，評估系統承載能力
- 定期進行安全性評估和滲透測試

## 題目二：API 伺服器異常排查流程
### 問題排查步驟

#### 初步診斷
- 檢查該機器的系統資源使用情況（CPU、記憶體、硬碟、網路）
- 查看系統日誌，尋找可能的錯誤訊息
- 檢查網路連接狀況和網路延遲

#### 深入分析
- 檢查應用程序日誌，查找異常紀錄
- 分析該機器的請求處理情況
- 檢查資料庫連接狀態
- 比對其他正常機器的配置差異

#### 監控與追蹤
- 使用 APM 工具追蹤請求處理流程
  具體工具選擇（New Relic、Dynatrace、Elastic APM）
  GC 監控, 線程池監控
  整合告警：

### 建議使用的工具組合：
- 基礎監控：CloudWatch + X-Ray
- JVM 監控：JMX Exporter + Prometheus + Grafana (JVM 層（JMX Exporter + Prometheus）)
- 系統監控：Zabbix

AWS CloudWatch 的監控能力：
- 基礎指標監控（CPU、記憶體、網路等）
- 自定義指標（Custom Metrics）
- 日誌監控（CloudWatch Logs）
- 應用程式監控（CloudWatch Application Insights）

AWS X-Ray：
- 分布式追蹤
- 服務地圖（Service Map）
- 請求追蹤和延遲分析
- 分析請求響應時間的分佈情況
- 檢查第三方服務依賴的響應時間

## 題目三：AWS EC2 SSH 連接問題排查
### 可能的原因分析

#### 系統層面
- 系統資源耗盡（CPU 100%、記憶體不足、硬碟空間不足）
- SSH 服務進程異常或未運行
- 系統最大文件描述符限制達到上限

#### 訪問控制
- SSH 密鑰問題
- Security Group 配置變更
- IAM 角色權限問題

### 解決方案
- 通過 AWS Console 查看系統日誌
- 使用 AWS Systems Manager Session Manager 嘗試連接
- 檢查 EC2 實例的狀態檢查結果

#### 長期改進
- 設置自動化監控和告警機制
- 實施備份和災難恢復方案
- 建立標準化的實例管理流程

## 題目四：新服務日誌接入 ELK/EFK 方案
### 實施步驟

#### 日誌收集配置
- 選擇適當的日誌收集方式（Filebeat/Fluentd）, 收集工具選擇

Filebeat：適用於文件類日誌收集
- 輕量級，資源佔用少
- 斷點續傳功能
- 內建多種模組

Fluentd：適用於容器環境
- 強大的插件生態
- 支持多目標輸出
- 適合 Kubernetes 環境

Logstash：適用於複雜的日誌處理
- 豐富的數據處理能力
- 支持多種輸入輸出
- 可處理複雜的日誌轉換


#### 日誌處理 - 日誌標準化與整體架構設計
- 配置日誌解析規則（Grok Pattern）
- 設置字段映射和類型轉換
- 實施日誌過濾和轉換邏輯

範例: (json)
{
  "timestamp": "ISO8601格式",
  "service": "服務名稱",
  "level": "日誌級別",
  "trace_id": "追蹤ID",
  "message": "日誌內容",
  "metadata": {
    "env": "環境標識",
    "version": "服務版本",
    "host": "主機信息"
  }
}

直接接入模式:
應用 -> Filebeat -> Elasticsearch
            |
            -> Kafka (備份)

緩衝模式模式:
應用 -> Filebeat -> Kafka -> Logstash -> Elasticsearch
                          -> SLS (備份)

前期準備
- 評估日誌量級
- 規劃存儲容量
- 設計索引策略
- 制定備份方案
- 生命週期策略


#### 監控與維護
- 監控日誌收集狀態
- 設置日誌保留策略
- 建立索引生命週期管理
- 配置適當的資源限制

### 注意事項
- 確保日誌格式的一致性
- 控制日誌量級，避免系統過載
- 實施日誌安全性控制
- 建立日誌備份機制

### 平台選擇考量因素
技術因素
- 部署複雜度
- 維護成本
- 擴展性能力
- 整合難易度

業務因素
- 數據量級
- 預算考量
- 團隊技術棧
- 監管要求

運維因素
- 可用性要求
- 災備需求
- 運維自動化
- 監控覆蓋