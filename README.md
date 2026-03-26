# README



**Fork repo info**

``` shell
# fork info
Fork base on: https://github.com/bnb-chain/node-deploy
Branch: main
Commit hash: ac7552da8f503dfdb154cf9f407d7acbf8705815

# submodule genesis
Fork base on: https://github.com/bnb-chain/bsc-genesis-contract.git
Branch: main
Commit hash: 34618f607f8356cf147dde6a69fae150bd53d5bf

# tag info
git tag -a bsc-fork-version -m "fork from https://github.com/bnb-chain/node-deploy" ac7552da8f503dfdb154cf9f407d7acbf8705815

# push tag
git push origin --tags
```



**Doc**


- https://docs.bnbchain.org
- https://docs.bnbchain.org/bnb-smart-chain/developers/node_operators/full_node/
- https://github.com/bnb-chain/bsc
- https://github.com/bnb-chain/node-deploy



# 一、bsc 部署配置

## 1.1 基础工具配置

> 安装基础工具



**系统环境：**

- ubuntu-24.04



**环境清单：**

- nodejs: v16.15.0
- npm: 6.14.6
- go: 1.24+
- foundry
- python3 3.12.x
- poetry
- jq



**node 安装**

```shell
# 版本查询
node --version

# nvm 安装
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

# node 安装 , 如果 lts 版本不行，可以替换成 16.15.0
nvm install --lts
```

 

**go 安装**

```shell
# 版本查询
go version

# 配置目录
sudo su - ubuntu
cd /;
sudo mkdir app
sudo chown -R ubuntu:ubuntu app/
mkdir -p /app/packages/go-packages
mkdir -p /app/bin

# go 下载
cd /tmp
wget https://golang.google.cn/dl/go1.26.1.linux-amd64.tar.gz

# go 安装
tar -zxvf go1.26.1.linux-amd64.tar.gz
mv go /app/bin/go1.26.1
cd /app/bin/;
ln -s go1.26.1 Go

# path 配置
vim ~/.bashrc

# app env
export APP_ROOT_PATH="/app"
export APP_BIN_PATH="${APP_ROOT_PATH}/bin"
export PATH="${PATH}:${APP_ROOT_PATH}:${APP_BIN_PATH}"

# go env
export GOROOT=/app/bin/Go
export GOBIN=${GOROOT}/bin
export GOPATH=/app/packages/go-packages
export GOMODCACHE="${GOPATH}/pkg/mod"
export PATH="${PATH}:${GOROOT}:${GOBIN}:${GOPATH}"

# 加载配置
source ~/.bashrc
```



**foundry 安装**

``` shell
# foundry 安装
curl -L https://foundry.paradigm.xyz | bash

# 初始化安装 forge，cast，anvil，chisel，程序运行依赖组件为 forge
foundryup
```



**Python3 安装**

```shell
# 版本查询
python3 --version
pip3 --version

# python3 安装

# pip3 安装
sudo apt install python3-pip
```



**Poetry 安装**

```shell
# 版本查询
poetry --version

# Poerty 安装，如果这里出现 SSL 证书安全错误，见错误处理章节进行错误处理
curl -sSL https://install.python-poetry.org | python3 -

# env 配置
vim ~/.bashrc

# poetry env
export PATH="${HOME}/.local/bin:$PATH"

# 加载配置
source ~/.bashrc
```



**jq 安装**

``` shell
# 版本查询
jq --version

# jq 安装

```



## 1.2 运行环境配置

>配置网络运行环境



**genesis 创建工具依赖环境安装**

```shell
# python env，如果这里出现 SSL 证书安全错误，见错误处理章节进行错误处理
cd /app/deploy-bsc/
pip3 install -r requirements.txt
```



**build validator**

``` shell
# This tool is used to register the validators into StakeHub.
cd create-validator
go build

# home dir
cd ../
```



## 1.3 配置文件说明

> 了解配置文件的主要信息即可



**binance 团队提到的下面文件可以自定义，但是从对程序的分析来看，尽量保持不变**

You can configure the cluster by modifying the following files:
   - `config.toml`
   - `genesis/genesis-template.json`
   - `genesis/scripts/init_holders.template`
   - `.env`



**参数情况说明：**

- 该部署工具程序由 binance 团队实现，便于用户快捷构建一个本地开发/测试网络
- 因为工具和部署程序中，存在很多内置环境变量，因此不要对 config.toml 和 genesis-template.json 做大量改动，否则可能会出现一些参数对不齐的情况
- 如下参数保持不变
  - chainID=714，程序中很多地方写死了这个值
  - KEYPASS="0123456789"，程序中很多地方写死了这个值
  - INIT_HOLDER="0x04d63aBCd2b9b1baa327f2Dda0f873F197ccd186"，程序中很多地方写死了这个值
  - INIT_HOLDER_PRV="59ba8068eb256d520179e903f43dacf6d8d57d72bd306e1bd603fdb8c8da10e8"，这个值程序不使用，是为了和对应的 address 一起进行记录
  - GENESIS_COMMIT="34618f607f8356cf147dde6a69fae150bd53d5bf"，这个值是 https://github.com/bnb-chain/bsc-genesis-contract.git 的 commit hash



## 1.4 env 参数配置

程序的整个执行过程中，主要配置 .env 的部份参数即可，其他不需要变动



**文件重命名**

``` shell
# rename env file name
cp env.example .env
```



**.env 环境变量配置说明**

``` shell
# 这些参数是关键变量，其他变量保持默认即可
BSC_CLUSTER_SIZE=4   # 代表 3个 archive + 1个 validator，可以根据需要修改更多节点
CHAIN_ID=714         # 保持默认，程序中多处写死该值
KEYPASS="0123456789" # 保持默认，多处配置文件使用该值
INIT_HOLDER="0x04d63aBCd2b9b1baa327f2Dda0f873F197ccd186" # 保持默认，程序中多处写死该值
# INIT_HOLDER_PRV="59ba8068eb256d520179e903f43dacf6d8d57d72bd306e1bd603fdb8c8da10e8" # 地址私钥，该值未启用
GETH_RPC_START_NUM=8547         # geth rpc 起始端口号，每个节点依次为 8547,8549,8551,8553, 每个节点递增2，程序写死
RPC_URL="http://127.0.0.1:8547" # 端口号和 geth rpc 起始端口号 保持一致，指向第1个节点端口
useLatestBscClient=false        # 第1次编译的时候设置为 true，程序自动拉取 bsc 源码编译 geth，后续改成 false，防止重复拉取
```



## 1.5 数据目录配置

**网络启动之后，默认数据目录位于 `.local/`** 

脚本中大量写死了该路径，暂未做调整，因此在部署的时候，如果放置脚本程序的所在存储区域没有足够的空间，

可以通过软链接的形式，修改数据存储目录，将实际数据存储于其他空间

``` shell
# 例如：将 .local/ 软链接到 /tmp/bsc 目录，实际数据存储于 /tmp/bsc 目录
ln -s /tmp/bsc .local
```



如果希望数据存储于 .local 目录，则可以忽略这里的配置，程序会自动创建 .local 目录

**对于本地开发测试，可以不配置，交给程序自动创建**

**对于部署长期使用的测试网络环境，建议这里根据实际情况调整**



# 二、bsc 网络部署

## 2.1 网络管理

- 部署/重置网络

``` shell
# reset and start a new cluster
./bsc_cluster.sh reset
```

- 启动网络

``` shell
# 启动全部节点
./bsc_cluster.sh start
```

- 停止网络

``` shell
# 停止全部节点
./bsc_cluster.sh stop
```

- 重启网络

``` shell
# 重启全部节点
./bsc_cluster.sh restart
```



## 2.2 rpc 测试

**余额查询**

``` shell
# 0x04d63aBCd2b9b1baa327f2Dda0f873F197ccd186 为网络部署后的默认持币地址
# 初始查询余额: 5亿
curl -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["0x04d63aBCd2b9b1baa327f2Dda0f873F197ccd186","latest"],"id":714}' \
  http://localhost:8547
```



**块高查询**

``` shell
curl -X POST -H "Content-Type: application/json" \
    --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":714}' \
  http://localhost:8547
```



**chainId 查询**

``` shell
curl -X POST -H "Content-Type: application/json" \
    --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":714}' \
  http://localhost:8547
```



## 2.3 log 查看

``` shell
# 查询节点0日志
./log.sh
./log.sh 0

# 查询节点1日志
./log.sh 1

# 查询节点2日志
./log.sh 2
```




# 三、bsc 浏览器部署

geth 兼容特性的浏览器部署程序，仓库地址

https://github.com/wulianapp/blockchain-deploy/tree/main/ether-explorer



# 四、错误处理

**python ssl 证书安全错误**

- 报错信息

``` shell
WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'SSLError(SSLCertVerificationError(1, '[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1000)'))': /simple/aiohttp/
WARNING: Retrying (Retry(total=3, connect=None, read=None, redirect=None, status=None)) after connection broken by 'SSLError(SSLCertVerificationError(1, '[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1000)'))': /simple/aiohttp/
WARNING: Retrying (Retry(total=2, connect=None, read=None, redirect=None, status=None)) after connection broken by 'SSLError(SSLCertVerificationError(1, '[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1000)'))': /simple/aiohttp/
WARNING: Retrying (Retry(total=1, connect=None, read=None, redirect=None, status=None)) after connection broken by 'SSLError(SSLCertVerificationError(1, '[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1000)'))': /simple/aiohttp/
WARNING: Retrying (Retry(total=0, connect=None, read=None, redirect=None, status=None)) after connection broken by 'SSLError(SSLCertVerificationError(1, '[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1000)'))': /simple/aiohttp/
Could not fetch URL https://pypi.org/simple/aiohttp/: There was a problem confirming the ssl certificate: HTTPSConnectionPool(host='pypi.org', port=443): Max retries exceeded with url: /simple/aiohttp/ (Caused by SSLError(SSLCertVerificationError(1, '[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1000)'))) - skipping
ERROR: Could not find a version that satisfies the requirement aiohttp==3.9.1 (from versions: none)
Could not fetch URL https://pypi.org/simple/pip/: There was a problem confirming the ssl certificate: HTTPSConnectionPool(host='pypi.org', port=443): Max retries exceeded with url: /simple/pip/ (Caused by SSLError(SSLCertVerificationError(1, '[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1000)'))) - skipping
ERROR: No matching distribution found for aiohttp==3.9.1
```

- mac 环境解决

``` shell
# 命令1
/Applications/Python\ 3.12/Install\ Certificates.command

# 如果上面的命令无法自动解决，执行这里的命令，进行手动解决
pip3 install --trusted-host pypi.org --trusted-host files.pythonhosted.org --upgrade certifi
pip3 install --upgrade pip

```

- linux 环境解决

``` shell
```



**externally-managed-environment**

- 报错信息

``` shell
pip3 install -r requirements.txt

error: externally-managed-environment

× This environment is externally managed
╰─> To install Python packages system-wide, try apt install
    python3-xyz, where xyz is the package you are trying to
    install.
    
    If you wish to install a non-Debian-packaged Python package,
    create a virtual environment using python3 -m venv path/to/venv.
    Then use path/to/venv/bin/python and path/to/venv/bin/pip. Make
    sure you have python3-full installed.
    
    If you wish to install a non-Debian packaged Python application,
    it may be easiest to use pipx install xyz, which will manage a
    virtual environment for you. Make sure you have pipx installed.
    
    See /usr/share/doc/python3.12/README.venv for more information.

note: If you believe this is a mistake, please contact your Python installation or OS distribution provider. You can override this, at the risk of breaking your Python installation or OS, by passing --break-system-packages.
hint: See PEP 668 for the detailed specification.
```

- linux 环境解决

``` shell
# 暂时不考虑使用 venv 环境管理，这样需要修改部署脚本，暂时使用全局安装管理
pip3 install -r requirements.txt --break-system-packages
```

