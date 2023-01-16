# replit-trojan

## 鸣谢

- [Project X](https://github.com/XTLS/Xray-core)

## 概述

本项目用于在 Replit 免费服务上部署 Trojan Websocket 协议。

支持 WS-0RTT 降低延迟，Xray 核心客户端在 Websocket 路径后加上 ?ed=2048 即可启用。

## 注意

 **请勿滥用，账号封禁风险自负。网络流量每月有100GB软上限。**
 
 **旧款安卓设备证书得不到更新，如无法连接，可尝试打开跳过证书验证**

## 部署
 
前往 replit.com 注册账户，然后点击下方按钮

<a href="https://repl.it/github/wy580477/replit-trojan">
  <img alt="Run on Repl.it" src="https://repl.it/badge/github/andbruibm/reader-replit" style="height: 40px; width: 190px;" />
</a>

再点击 Import from Github。

### 一键自动部署

点击网页上方 Run，稍等片刻即部署完成，右侧console窗口会自动输出分享链接和二维码，可以使用v2rayn/v2rayng客户端扫码。

Trojan密码和Websocket路径为随机生成，存储在Repl数据库里。

### 手动设置部署

点击左侧Secrets，在右侧选项卡分别设置 PASSWORD（Trojan协议密码）和 WSPATH（Websocket路径）变量。

![image](https://user-images.githubusercontent.com/98247050/205805317-349f4814-5d1b-4fba-8d53-7de12a7f1810.png)

然后点击网页上方 Run，稍等片刻即部署完成。

手动客户端设置示例，右侧 Webview 预览选项卡地址栏内为服务器域名：

![image](https://user-images.githubusercontent.com/98247050/205805711-75a6ddcf-20c6-4e2c-a90a-05dc979ade45.png)

如需设置自定义域名，点击 Webview 预览选项卡的地址栏右侧铅笔图标，即可进入向导。



