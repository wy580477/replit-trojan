## Replit 已经停止了 repl.co 域名的免费部署服务，本项目存档

# replit-trojan

## 鸣谢

- [SagerNet/sing-box](https://github.com/SagerNet/sing-box)

## 概述

本项目用于在 Replit 免费服务上部署 Trojan Websocket 协议。

支持 WS-0RTT 降低延迟，Xray 核心客户端在 Websocket 路径后加上 ?ed=2048 即可启用。

## 注意

 **请勿滥用，账号封禁风险自负。免费账户网络流量每月有10GB上限。**
 
 **旧款安卓设备证书得不到更新，如无法连接，可尝试打开跳过证书验证**

## 部署
 
 **已无法从本库直接部署。**

 1. 下载[仓库文件](https://codeload.github.com/wy580477/replit-trojan/zip/refs/heads/main)，然后解压缩。
 
 2. 新建一个 blank repl。

 3. 将解压缩得到的除 README 外的文件，拖动到 repl 项目页面左侧 Files 处: 

    ![image](https://user-images.githubusercontent.com/98247050/236609539-4748e5e1-bd9c-4db1-95d3-6c55b20d6fe8.png)

    页面会弹出 overwrite 提示，全部点确定。

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



