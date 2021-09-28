# Docker笔记

@ Aiken 2020

同时本文章将包含在windows的wsl2环境下搭建docker以及将wsl2和docker的存储位置迁移到数据盘上的问题。（后续可以将一些数据挂载到其他的盘中，比如一些实验的空间之类的，等不用了在传入原本的盘中）
参考资料：[docker从入门到实践](https://yeasy.gitbook.io/docker_practice/image);[docker volume讲解](https://loocode.com/post/10105)

## 进行本机离线阅读

**gitbook形式阅读为例：**

启动：拉取镜像和运行容器. 启动服务之后再浏览器输入localhost:4000 / 127.0.0.1:4000，进行阅读即可。

停止：再CMD ctrl+c或者再Docker终端关闭容器把。

```bash
# 为了保持内容最新,建议在每次阅读之前pull镜像
# 安装完镜像以后就可以在hub中进行pull等操作了
$ docker pull ccr.ccs.tencentyun.com/dockerpracticesig/docker_practice

# 国内仓库
$ docker run -it --rm -p 4000:80 ccr.ccs.tencentyun.com/dockerpracticesig/docker_practice

# docker hub
# $ docker run -it --rm -p 4000:80 dockerpracticesig/docker_practice
```

**基于镜像阅读服务下载PDF**

安装 gitbook：`npm install -g gitbook-cli` 

查看是否安装成功： `gitbook -V`

上一步中可能会出现**BUG**： cb is not a function [解决方案](https://blog.csdn.net/cuk0051/article/details/108319622)



打开gitbook的目录并在**GITHUB项目的目录**中执行 

`gitbook serve .` 之后同样可以在localhost4000 访问

`gitbook pdf .` 在文件目录保存pdf

BUG：not such file 暂未解决，先在网上看吧

## 笔记目录（TODO）

从目录开始正式做一些整理，也就是一些重要的信息，操作，以及理解。普通的一些就没必要再记录了。

- 定制镜像的操作，添加ssh 账号密码passwd命令之类的操作
  [相关参考资料](https://www.baidu.com/s?ie=utf-8&f=8&rsv_bp=1&tn=baidu&wd=%E5%AE%9A%E5%88%B6%E9%95%9C%E5%83%8F%20%E8%AE%BE%E7%BD%AE&oq=%25E7%25BB%2599docker%25E5%258A%25A0%25E5%25A3%25B3&rsv_pq=c749606500027ca2&rsv_t=27386gYSsWKvxkj4l7MwERtHKYqJf8jYIgZcPieFbES315fXDd4vS922hxU&rqlang=cn&rsv_enter=1&rsv_dl=tb&rsv_btype=t&inputT=3650&rsv_sug3=80&rsv_sug1=20&rsv_sug7=100&bs=%E7%BB%99docker%E5%8A%A0%E5%A3%B3)，初步尝试是失败了
- 以及使用portainer去构建一个简单的容器的操作，让我们试一试；
- SSH链接的原理和实现；
- **wsl2下docker中cuda 装pytorch的操作**
  https://zhuanlan.zhihu.com/p/149517344
  https://zhuanlan.zhihu.com/p/337758917
  https://blog.csdn.net/fleaxin/article/details/108911522
  https://blog.csdn.net/weixin_42882838/article/details/106976430
  https://www.cnblogs.com/dadream/p/13640143.html
  https://docs.nvidia.com/cuda/wsl-user-guide/index.html#getting-started
- 摘抄师兄的笔记中有用的部分；

## WSL2以及Docker（win）的存储位置迁移

[docker](https://blog.csdn.net/qq_34306480/article/details/109895891?utm_medium=distribute.pc_relevant.none-task-blog-baidujs_title-7&spm=1001.2101.3001.4242)；[WSL2](https://blog.csdn.net/x356982611/article/details/108641601)；

首先建议先在docker-desktop中设置好绑定的WSL version，然后在一次shut down 过程中完成两者的迁移操作，避免不必要的重复操作；

### 默认的存储位置（用来确认迁移状态）

docker：`%LOCALAPPDATA%/Docker/wsl`

wsl2: `%LOCALAPPDATA%/packages/c......./local_state`

### 存储位置迁移

```bash
# 关闭wsl服务
wsl --shutdown
# 查看关闭状态
wsl -l -v
# 导出wsl2 system； docker-desktop & docker-desktop-data
# 导出系统 wsl --export <DistroName> <PathToTarArchive>
wsl --export Ubuntu-20.04 E:\WSLWorkspace\ubuntu.tar
wsl --export docker-desktop E:\WSLWorkspace\docker-desktop\docker-desktop.tar
wsl --export docker-desktop-data E:\WSLWorkspace\docker-desktop-data\docker-desktop-data.tar
# 删除（注销）系统
wsl --unregister Ubuntu-20.04
wsl --unregister docker-desktop
wsl --unregister docker-desktop-data
# 导入系统到指定的新位置(使用新路径导入新系统)
wsl --import Ubuntu-20.04 E:\WSLWorkspace E:\WSLWorkspace\ubuntu.tar
wsl --import docker-desktop E:\WSLWorkspace\docker-desktop E:\WSLWorkspace\docker-desktop\docker-desktop.tar
wsl --import docker-desktop-data E:\WSLWorkspace\docker-desktop-data E:\WSLWorkspace\docker-desktop-data\docker-desktop-data.tar
# 启动docker-desktop服务
# 启动WSL2服务（这里在terminal中会出现两个ubuntu的unid，把原本的第一个给注释掉才行）
# 设置默认wsl2用户
ubuntu2004.exe config --default-user xxx
# 删除多余的所有tar，over
```

## 镜像获取和运行

[Docker Hub](https://hub.docker.com/search?q=&type=image) 上有很多高质量的镜像，这是**主要的镜像获取途径**

找到需要的镜像以后执行相关操作拉取镜像

```bash
$ docker pull [选项] [Docker Registry 地址[:端口号]/]仓库名[:标签]
#查看选项👇，是一些比较特殊的一般情况下用不到的操作
$ docker pull -help 
#如果是从dockerhub中获取镜像的话一般是不需要地址和端口号的
```

在拥有镜像以后就可以**基于镜像运行容器**（本质是作为进程存在的）

如果我们希望启动bash并进行交互式操作：

```bash
$ docker run -it --rm ubuntu:18.04 bash
# 参考上面运行reading的步骤也可以设置local端口吧
```

- `-it`：这是两个参数，一个是 `-i`：交互式操作，一个是 `-t` 终端。我们这里打算进入 `bash` 执行一些命令并查看返回结果，因此我们需要交互式终端。
- `--rm`：这个参数是说容器退出后随之将其删除。默认情况下，为了排障需求，退出的容器并不会立即删除，除非手动 `docker rm`。我们这里只是随便执行个命令，看看结果，不需要排障和保留结果，因此使用 `--rm` 可以避免浪费空间。
- `ubuntu:18.04`：这是指用 `ubuntu:18.04` 镜像为基础来启动容器。
- `bash`：放在镜像名后的是 **命令**，这里我们希望有个交互式 Shell，因此用的是 `bash`。
- `-d` : 后台模式 `--name`: 指定 容器的名字
- `--restart=always` # docker重启后容器也一起重启
- `-p`:  #端口映射指令
- `-v`:  -v 本地目录:容器目录 或 -v 容器目录


**其他的一些常用指令**

```bash
# 查看所有镜像 （过滤器操作参见文档）
docker image ls [可选参数：1仓库名：2标签]
# ID和...的前面要加.
docker image ls --format "{{ID}}: {{Repository}} {{Tag}}"
# 查看镜像的体积
docker system df
# 虚悬镜像的查看和删除
docker image ls -f dangling=true
docker image prune
# 删除镜像（不需要完整的ID只需要能区分就行）
基于ID：$ docker image rm [选项] <镜像1> [<镜像2> ...]
基于镜像名： $ docker image rm <仓库名>：<标签>
```

比如，我们需要删除所有仓库名为 `redis` 的镜像：

```bash
$ docker image rm $(docker image ls -q redis)
```

##  Portainer 的安装设置

首先列出portainer的一些**相关参考资料：** 基本上是基于这些参考资料进行的学习

[docker管理工具portainer介绍安装和使用](https://blog.csdn.net/u010244957/article/details/89350146) |  [Docker管理面板](http://www.senra.me/docker-management-panel-series-portainer/) |  [Portainer简明使用教程](https://post.smzdm.com/p/apz3ldw0/)

[Docker镜像部署与运维指南](http://help.websoft9.com/docker-guide/docker/solution/install-mysql.html)

[Portainer for Win10 数据卷](https://blog.csdn.net/stoneLSL/article/details/102773325) | 

**PART 1 Download And Install Image**

```bash
# 查询镜像
$ docker search portainer
# 下载镜像（官方那个）
$ docker pull portainer/portainer

```

**PART 2  单机版运行**

如果我们使用的是单docker宿主主机，就直接单机运行portainer服务器，不需要进行联网操作，Just Do it：

需要注意的是，启动了WSL的windows单机实际上也要执行linux的命令才能正确的启动。

```bash
# 这样已经可以了但是还可以考虑指定数据挂载路径，下面这个是Linux的情况

$ docker volume create portainer_data
$ docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
# Windows
$ docker run -d -p 9000:9000 --name portainer --restart=always -v //./pipe/docker_engine://./pipe/docker_engine portainer/portainer
```

通过LocalHost或者指定ip以及Port(9000)登录Portainer

## 常用端口映射

Container中有一些指令或者文件是需要一个端口的，所以我们需要将虚拟的端口映射到物理端口上，方便后续的远程链接，比如说ssh，所以我们需要，在启动镜像之前，进行物理端口的映射。

### 需要被映射的端口

ssh：默认扫描 `22` 端口

tensorboard: 

默认 `6006`端口，常用`8008` 端口

```bash
# 启动的时候可以指定端口
$tensorboard --logdir=/tmp  --port=8008
```

jupyterlab：默认`8888`端口

备用和常用 9999 之类的

### 可用端口

windows端口号相关操作：(0-65535) 建议使用5000以外的端口，

```bash
# 查看所有被打开的端口（不知道是不是只能使用这些。）
$netstat -an 
# 查看电脑端口的占用
$netstat -ano
# 在相关指令下查找某个端口 for example
$netstat -an0 | findstr "80"
```

## 基本镜像定制

该部分主要介绍最基本的ssh开启和passwd建立的操作，设定ssh和建议指定的root账户，从而对container进行更好的管理，这样的操作可以方便环境的配置。但是实际上也可以在安装完基本docker之后在进行一个个的安装吧，我觉得这应该是可以的。

[:star:至关重要师兄的文档](https://gitee.com/qi-tianliang/conda_gpu_in_docker)

**Pytorch Based**

我们基于 [pytorch官方镜像](https://hub.docker.com/r/pytorch/pytorch)，进行Pytorch工程环境的构建，其中默认的python环境是通过`conda`控制的，已经集成在其中了，在下载镜像的时候我们需要明确`cuda`和`nvdia`环境.

pull 镜像之后，我们采取portainer**进行镜像的启动管理**，

- 端口映射
- Volume 设置物理存储卷设置
- 启动模式
- dockerfile的构建

**Dockerfile**

下面是一些需要写在dockerfiles中的操作，对于命令的一些解读，我们之后还是需要进一步的了解。指令的写法和详细的作用

- open ssh、passwd、git之类的安装
- 设置bash、root、软连接、
- 暴露ssh端口
- 设置一些依赖包
- 清楚copy的安装文件

基本的dockerfiles模板如下所示。如果是tensorflow的话我觉得差别也不会太大，之后补充。

```dockerfile
# BASE IMAGE
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04 

# LABEL MAINTAINER
LABEL maintainer="ltobenull@gmail.com"

SHELL ["/bin/bash","-c"]

WORKDIR /tmp
# copy安装文件
COPY Python-3.6.9.tar.xz /tmp
# 设置 root 密码
RUN echo 'root:password' | chpasswd \
# 安装openssh-server 并配置
  && apt-get update && apt-get -y install openssh-server \
  && sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config \ 
  && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config \
  && mkdir /var/run/sshd \
# 安装python依赖包
  && apt-get -y install build-essential python-dev python-setuptools python-pip python-smbus \
  && apt-get -y install build-essential libncursesw5-dev libgdbm-dev libc6-dev \
  && apt-get -y install zlib1g-dev libsqlite3-dev tk-dev \
  && apt-get -y install libssl-dev openssl \
  && apt-get -y install libffi-dev \
# 安装python 3.6.9
  && mkdir -p /usr/local/python3.6 \
  && tar xvf Python-3.6.9.tar.xz \
  && cd Python-3.6.9 \
  && ./configure --prefix=/usr/local/python3.6 \
  && make altinstall \
# 建立软链接
  && ln -snf /usr/local/python3.6/bin/python3.6 /usr/bin/python3 \
  && ln -snf /usr/local/python3.6/bin/pip3.6 /usr/bin/pip3\
# 安装pytorch
  && mkdir ~/.pip && echo -e '[global] \nindex-url = https://mirrors.aliyun.com/pypi/simple/' >> ~/.pip/pip.conf \
  && pip3 install torch===1.2.0 torchvision===0.4.0 -f https://download.pytorch.org/whl/torch_stable.html \
# 清理copy的安装文件
  && apt-get clean \
  && rm -rf /tmp/* /var/tmp/*

EXPOSE 22
# 每次启动docker的时候都自启动ssh
CMD ["/usr/sbin/sshd", "-D"]
```

## Portainer 相关操作（需要更新）

@ 基于196的实验室docker管理作为instance，然后基于自己的安装操作来写这一部分的介绍。

[:star:重中之重基于3090的portainer管理 ](https://gitee.com/qi-tianliang/recommended_server_usage)

### 物理机资源介绍

物理机的账户用于在物理机上创建自己的目录，进行管理和维护，除此之外请尽量避免直接使用物理机进行操作，避免误操作风险。

196的FS（file system）结构如下：

![image-20201030205525273](https://raw.githubusercontent.com/AikenH/md-image/master/img/image-20201030205525273.png)

在物理机上进行操作的时候：

- 在`/opt/data3/developers`下创建**自己名字命名的文件夹**作为自己的`workspace`（这也是后面物理机挂载的时候的重要指标）

- NOTE：创建新容器或者需要较大存储空间的操作的时候要检查硬盘的余量`$df-h`是否足够

### 使用Portainer管理

在这种高度可视化的界面下，已有的Image的使用，从dockerhub pull等的操作就不多说了（优先使用本地的），

通常登录的端口都是9000：`202.117.43.196:9000`

My Account（密码同）：`hongzx`   



**新容器的创建注意事项**

- 记得勾选auto remove

![image-20201030210255747](https://raw.githubusercontent.com/AikenH/md-image/master/img/image-20201030210255747.png)

- **端口设置**（也就是旁边的端口转发）
  具体需要设置的参见上面的常见端口的安排

![image-20201030210426422](https://raw.githubusercontent.com/AikenH/md-image/master/img/image-20201030210426422.png)

- 196的端口占用表（**我的部分**）：

| user        | Occupy      |
| ----------- | ----------- |
| hongzhenxin | 23600-23699 |

**数据卷挂载&GPU设置**

包括将存储数据挂载到物理机上的指定盘点，以及开放CUDA的使用

![image-20201030210828383](https://raw.githubusercontent.com/AikenH/md-image/master/img/image-20201030210828383.png)

1. 绑定路径设置（主要的文件要传到挂载的路径下面）

![image-20201030210920029](https://raw.githubusercontent.com/AikenH/md-image/master/img/image-20201030210920029.png)

2. GPU设置：

   ![image-20201030210944392](https://raw.githubusercontent.com/AikenH/md-image/master/img/image-20201030210944392.png)

## Docker BASH 美化

基于zsh和oh my zsh对命令行主题进行美化

```bash
# 安装zsh
$ sudo apt-get install zsh
# 修改默认shell为zsh
$ chsh -s /bin/zsh
# 安装oh-my-zsh
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# 或者使用wget
$ sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```

如果我们需要将默认终端恢复bash：

```bash
$ chsh -s /bin/bash root
# h或者尝试直接输入bash
```

https://traceme.space/blog/page/6/zshoh-my-zshtmuxvimdocker/ 配置教程

### 切换主题部分

除了第一个命令其他的都在文档中修改/添加

https://github.com/ohmyzsh/ohmyzsh/wiki/Themes 主题预览

```bash
# 切换主题等
$ code ~/.zshrc
$ZSH_THEME="tonotdo" 
# （笔者比较喜欢这套主题，可自行选择，或者随机使用）
$ setopt no_nomatch  
# （在文档末尾添加，解决zsh语法与bash语法不太兼容的问题，更多请参考[1]）
$ export TERM=xterm-256color 
#（设置终端色彩模式，vim使用airline增强状态栏，需要此模式）
```

### 出现的问题

conda activate消失
解决办法：

```bash
# 保守方法，已测试 workflow如下
# 先将主题切换为bash
# 在vscode的默认启动项中将启动的terminal切换回bash
$ chsh -s /bin/bash
# 卸载oh_my_zsh, and zsh
$ sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/uninstall.sh)"
$ apt-get remove zsh
# 进入portainer，在portainer的bash中执行
$ conda init 
# 之后在所有环境中都不需要再执行这个activate的操作了
```

但是好像在mobaxterm中还是需要手动激活一下，但是至少activate回来了

##  Connect refused 

首先检查Linux Host 的SSH 是否启动，如果没有启动的话，手动启动，特别注意再重新run container的时候，要注意执行以下命令启动ssh service：

```bash
$ service ssh start 
# 通过ps 查看sshd的服务是否运行
$ ps -aux | grep ssh
# finished
```

