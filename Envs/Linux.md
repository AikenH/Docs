# Linux 常用操作

@aiken 2020

## Readme

这篇文章主要是基于Ubuntu来进行编写的，其他的一些发行版的操作，暂不考虑；

记录一些基本的常用操作，方便后续使用和查找之类的

⚡https://www.runoob.com/w3cnote/linux-common-command-2.html

⚡LINUX shell百科：https://www.explainshell.com/explain/1/ps

**Linux资源汇总**

收录一些Linux的工具书以及相关的OnLine-Doc，方便后续进行学习和查阅：

先从3开始看吧，其他的慢慢看，我觉得一天看一点点就差不多了，不要为难自己。

1. [鸟哥的Linux私房菜](http://cn.linux.vbird.org/linux_basic/linux_basic.php)：相对全面一点但是内容有点太多了
2. [Linux就该这么学](https://www.linuxprobe.com/chapter-00.html)：从开始到结束的流程挺完善的，但是这个网站做的事纯傻逼
3. [Linux Tools Quick Tutorial](https://linuxtools-rst.readthedocs.io/zh_CN/latest/index.html#)：简单入门教程好像是
4. Linux命令行于Shell脚本编程大全：本地PDF，在当前文件夹下面进行查看

---

## 文件架构

[Linux各文件夹的含义](https://www.cnblogs.com/sijizhen/p/10576049.html)
该部分分析LInux下的文件架构体系，最外层的一些系统文件夹的基础作用以及对应的特殊功能等等，
该部分分析的必要性主要在于我们能够更清楚我们文件的存储体系以及系统文件的处理方面。

- `/tmp`：临时文件夹，系统会定期清理其中的文件，用来存放一些下载和安装的文件

- `/mnt`: mount挂载文件夹，作为挂载目录来使用，比如在WSL中，对应的就是windows系统的文件

- `/etc `:用来存放所有的系统管理所需要的配置文件和子目录，linux正是因为这些文件才能正常运行

- `/home`: 个人文件夹，在home下会有自己的user dir,通常情况下我们的工作区和对应的其余资料都会放在这个部分

- `/bin`: 是binary的缩写,包含了引导系统启动所需的命令和普通用户可以使用的常用命令

- `/root`: 系统管理员的主目录

- `/var`:这个目录中存放着那些不断在扩充着的东西，为了保持/usr的相对稳定那些经常被修改的目录可以放在这个目录下，实际上许多系统管理员都是这样干的顺带说一下系统的日志文件就在/var/log目录中。

- `/usr`: 最庞大的目录，要用到的应用程序和文件几乎都在这个目录

  

## 各种类型的指令

按照使用场景对各种指令进行分类整理，对各种命令有一个更好的理解。

### 压缩、解压缩文件操作

各种压缩指令对应不同的命令和设置，其中压缩文件可以包含一下的几种：

`tar.gz`, `zip` `7z`

**zip files** 后缀
```bash
==== zip and unzip .zip files ==========
# we need to install the package for .zip
sudo apt-get install zip
# r means recurrent（递归的遍历）
zip -r newpackage.zip dir1
# unzip files to target dir
unzip zipfiles.zip -d dir/*
```

```
-m: 压缩文件删除源文件
-o: 将压缩文件的最新变动时间设置为压缩的时间
-r: 递归压缩，目录下的所有子级目录一并压缩
-x: “文件列表”，压缩时排除文件列表中的文件
```

**tar.gz files**

[tar压缩解压缩命令详解](https://www.cnblogs.com/hhandbibi/p/7283862.html)

```bash
# 压缩文件
tar -zcvf files.tar.gz dir
tar -zcvf files.tar.gz *.md
# .tar文件
tar -xvf file.tar -C 指定目录
tar -xvf file.tar dir/
# .gz文件
gzip -d
```

#### 批量解压tar到相应的文件夹中

有几种不同的写法，这里看一下bash的相应手册，看看我们到底需要采用哪一种来执行

一下实现相应的bash脚本来执行对应的操作：

这里有需要注意的是单引号和相应的顿号要进行区分不然会发生不对的问题

```bash
# version 1 ez2understrand
for i in `ls *.tar.gz`
do
	mkdir /dir/${i/.tar.gz//}
	tar zxvf $i -C /dir/${i/.tar.gz//}
done

# version 2 try to use assignment method
# 可以发现基本的操作是一样的，就是对应的定义的地方
# 可以考虑一下是如何使用echo和cut以及对应的-d 和 -f1是什么意思
for file in `ls *.tar`
do
	todir=`echo $file | cut -d"." -f1`
	mkdir $todir && tar -xvf $file -C $todir
done
```

### 文件操作相关

1. 建立文件夹：

```bash
mkdir foldername
```

2. 删除文件/文件夹：

```bash
 rm -[option] filename
 rm -[option] foldername
```

[option]:

> "rm -f" 强行删除，忽略不存在的文件，不提示确认。(f为force的意思)
>
> "rm -i" 进行交互式删除，即删除时会提示确认。(i为interactive的意思)
>
> "rm -r" 将参数中列出的全部目录和子目录进行递归删除。(r为recursive的意思)
>
> "rm -v" 详细显示删除操作进行的步骤。(v为verbose的意思)

​	删除文件夹中的文件不删除文件夹

```bash
 rm  -rf /test/*
```

3. 查看某个文件夹下文件或者文件夹的个数：

参考链接：https://blog.csdn.net/niguang09/article/details/6445778

```bash
# 查看某个文件夹下文件的个数
# 2.包括了子文件夹下的文件 3.之查看文件夹 4. 包括子文件夹中的文件夹
ls [dirname] -l|grep "^-"| wc -l
ls [dirname] -lR|grep "^-"| wc -l
ls [dirname] -l|grep "^d"| wc -l
ls [dirname]-lR|grep "^d"| wc -l
# 通过管道查看
 ll | wc -l
```

4. 查看文件夹和磁盘的空间占用

[explain_shell du](https://www.explainshell.com/explain/1/du)

df 命令可以显示目前所有文件系统的可用空间和使用情形

``` bash
# 参数 -h 表示使用「Human-readable」的输出，也就是在档案系统大小使用 GB、MB 等易读的格式。
 df -h
```

:zap: du:查询文件或者当前文件夹的磁盘使用空

```bash
# 查询当前文件夹下面各个文件夹的大小：
# 将深度改成n应该可以改变递归到子文件夹下的深度
du -h --max-depth=1 *
# *代表的是当前文件目录
du -h --max-depth=1 [path]
```

5. 移动或者重命名文件(mv)


```bash
# 将文件A重命名为文件B
mv nameA nameB
# 移动文件到指定目录下
mv files dir/
```

6. 拷贝文件(cp)

```bash
# using cp to copy file
cp dir1/filea dir2/filea.bak
```

7. 列出文件(ls)

```bash
ls -a 
# list the file in the sub dir too
ls -R 
ls -a -l -R 
```



### 进程操作

一些常用的进程操作命令，罗列如下，由于远程的链接常常中断，我们会需要手动终止一些进程，避免多余的内存、chache和性能占用。

TODO：

- 如果我们中断了远程链接，如何避免进程被kill，（也可以参考mobaxterm）
- 同时在下次链接的时候，切换到该bash中。
  - [解决方案1 ](https://huanghailiang.github.io/2017/09/08/ssh%E8%BF%9E%E6%8E%A5%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B8%AD%E6%96%AD%EF%BC%8C%E5%A6%82%E4%BD%95%E8%AE%A9%E5%91%BD%E4%BB%A4%E7%BB%A7%E7%BB%AD%E5%9C%A8%E6%9C%8D%E5%8A%A1%E5%99%A8%E6%89%A7%E8%A1%8C/)
  - [解决方案2 ](https://www.centos.bz/2018/01/ssh-%E7%94%A8screen%E6%81%A2%E5%A4%8D%E4%BC%9A%E8%AF%9D/)

```bash
# 常用命令如下
# 搜先列出包含所有其他使用者的进程
ps -aux
 htop
# 针对进程的PID进行关闭
 kill PID
# 如何执行批量的进程操作

```

> 更多相关**ps的可选操作**可以参考https://www.explainshell.com/explain/1/ps
>

### 下载安装相关操作

**安装没安装完成的包：**

`sudo apt-get install package --fix-missing`

**更新源：**

很多情况下Ubuntu的Source是被屏蔽的，所以我们需要使用国内源进行替代，来提升我们的下载和安装的速度

```bash
# backup the source files in cases that sth wrong
sudo cp /etc/apt/sources.list /etc/apt/source.list.bak

# using sudo to modify or recreate the source.list files
sudo nvim /etc/apt/source.list

# replace the content of it
=== TSINGHUA SOURCE ===

# update the source info
sudo apt update

# update the files to varify the speed.
sudo apt upgrade
```

实际上换源只要找到对应的ubuntu的发行版，也就是在源链接后面的形式，然后将前面的url改成对应的源即可

[All the source list](https://www.myfreax.com/how-to-change-the-software-source-of-ubuntu-20-04/)；[清华源更新地址](https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/);[聚合](https://www.cxyzjd.com/article/amyzhang1234/101555284)；[XJTU](https://mirrors.xjtu.edu.cn/help/ubuntu.html)；[Alibaba](https://developer.aliyun.com/mirror/ubuntu?spm=a2c6h.13651102.0.0.3e221b11newPW7)

```ini
==================== aliyun source ===================
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
```

#### wget and curl command

如何使用`wget`和`curl`下载和安装服务

### grep 命令行输出查找

通过grep在命令行中筛选输出显示，只显示grep指定的部分。

```bash
# 只显示其中包括str的部分
 command | grep 'str'
```

### GPU、CPU信息

Linux查看显卡信息：

```bash
lspci | grep -i vga
# 如果是nvidia还可以
lspci | grep -i nvidia
# 最常用：或者使用nvidia的自带命令
nvidia-smi
```

监视GPU使用情况

```bash
watch nvidia-smi
# or
gpustat --watch
```

显示CUDA版本

```bash
cat /usr/local/cuda/version.txt
```

查看CPU：[相关信息](https://blog.csdn.net/qq_38025219/article/details/88849637)

显示CPU个数：

```bash
cat /proc/cpuinfo |grep "processor"|wc -l
```



## 非特定的系统指令

一些特殊的通用命令

### WATCH

将watch加在前面可以监控一些信息的实时变化

```bash
watch ps -aux
watch nvidia-smi
```

### HISTORY

HISTORY主要针对如何找到历史指令，如何重复执行某一行指令；

```bash
# show the history command idx
history
 1262 btm

# resume this command idx, it'll get command by the idx
!1262
 btm
```

如果我们希望通过关键词搜索指令，然后进行重新调用：

```
<ctrl + r> + <方向键> 选择命令
```

### ln -s

Linux 软连接，类似windows系统中做快捷方式

```bash
# 在target地址建立一个名为linkname的软连接，链接到source_dir
ln -s source_dir/ target_dir/linkname
# 删除软连接(注意后面千万不能有/)，不然会将文件全部删除
rm -rf linkname
```

### HEAD、TAIL

只显示命令行输出的前几条或者后面几条

```bash
history | head -i
histo | tail -i
```

## 远程操作

### 启动ssh服务

```bash
service ssh start
```

### 避免远程终端执行的代码中断

我们希望再退出窗口的时候没有退出终端执行中的代码的话，我们实际上可以使用一种叫做session的设置来进行操作，如果要支持session的功能，这里主要可以有两种工具：

1. [tmux (zhihu.com)](https://zhuanlan.zhihu.com/p/102546608)
2. screen

我们这里主要选择使用tmux，功能相对于screen来说更全面一些，分屏功能也更好用

#### 配置文件设置

新版本的时候出现了问题，等待更新，[official example](https://github.com/tmux/tmux/blob/master/example_tmux.conf)，[tutor](http://louiszhai.github.io/2017/09/30/tmux/#%E6%96%B0%E5%A2%9E%E9%9D%A2%E6%9D%BF)

在`~`目录下生成配置文件，然后写入我们希望的配置

```bash
vim ~/.tmux.conf
```

:x:主要包含相关的按键映射以及页面主题等等操作

```bash
# use alt+arrpw to switch panes
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# mouse mode
set -g mouse on

# set easier window split keys
bind-key v split-window -h
bind-key h split-window -v

#Enable oh my zsh in tmux
set -g default-command /usr/bin/zsh

#################################### config color ######################################
set -g default-terminal "screen-256color"

## COLORSCHEME: gruvbox dark
set-option -g status "on"

# default statusbar color
set-option -g status-style bg=colour237,fg=colour223 # bg=bg1, fg=fg1

# default window title colors
set-window-option -g window-status-style bg=colour214,fg=colour237 # bg=yellow, fg=bg1

# default window with an activity alert
set-window-option -g window-status-activity-style bg=colour237,fg=colour248 # bg=bg1, fg=fg3

# active window title colors
set-window-option -g window-status-current-style bg=red,fg=colour237 # fg=bg1

# pane border
set-option -g pane-active-border-style fg=colour214 #fg2
set-option -g pane-border-style fg=colour237 #bg1

# message infos
set-option -g message-style bg=colour239,fg=colour223 # bg=bg2, fg=fg1

# writing commands inactive
set-option -g message-command-style bg=colour239,fg=colour223 # bg=fg3, fg=bg1

# pane number display
set-option -g display-panes-active-colour colour214 #fg2
set-option -g display-panes-colour colour237 #bg1

# clock
#set-window-option -g clock-mode-colour colour109 #blue
set-window-option -g clock-mode-colour colour239 #blue

# bell
set-window-option -g window-status-bell-style bg=colour167,fg=colour235 # bg=red, fg=bg

## Theme settings mixed with colors (unfortunately, but there is no cleaner way)
set-option -g status-justify "left"
set-option -g status-left-style none
set-option -g status-left-length "80"
set-option -g status-right-style none
set-option -g status-right-length "80"
set-window-option -g window-status-separator ""

#################################### config status ######################################
set-option -g status-left "#[fg=colour248, bg=colour241] #S #[fg=colour241, bg=colour237, nobold, noitalics, nounderscore]"
set-option -g status-right "#{prefix_highlight}#[fg=colour239, bg=colour237, nobold, nounderscore, noitalics]#[fg=colour246,bg=colour239] %Y-%m-%d %H:%M #[fg=colour248, bg=colour239, nobold, noitalics, nounderscore]#[fg=colour237, bg=colour248] #h"

set-window-option -g window-status-current-format "#[fg=colour237, bg=colour214, nobold, noitalics, nounderscore] #[fg=colour239, bg=colour214] #I #[fg=colour239, bg=colour214, bold] #W #[fg=colour214, bg=colour237, nobold, noitalics, nounderscore]"
set-window-option -g window-status-format "#[fg=colour237,bg=colour239,noitalics]#[fg=colour223,bg=colour239] #I#[fg=colour223, bg=colour239] #W #[fg=colour239, bg=colour237, noitalics]"
```

#### 基本的常用操作

- tmux 前缀按键：`ctrl+b`

```bash
# tmux 新建，离开，重连，关闭，列表，重命名
tmux new -s <session-name>
tmux detach  # 或者prefixKey + d
tmux attach -t <session-name>
tmux kill-session -t <session-name>  # 或者直接exit
tmux kill-windows -t <windows-name>
tmux ls
tmux rename-session -t <old-session-name> <new-session-name>  # prefixkey + b 
```

### SCP：linux之间传文件（好像也支持和Windows互传）

使用指令scp -P localfile username@ip remotepath

出现问题：permission denied：使用chmod 修改远程文件夹权限，774 or 777

具体指令Google it

### SZ、RZ命令

sz、rz命令是Linux、Unix与Windows进行ZModem文件传输的命令；

`sz`： sent zmodern 从服务器传输文件到的本地

`rz`：reveice 从windows传递文件到Linux服务器

---

if we want use this we need to inster '`lrzsz`' first：

## 环境配置

查看当前的ubuntu版本：

```bash
# method 1 
cat /proc/version
# method 2
cat /etc/issue
```

基础命令：修改密码` passwd`

### Install Vim/NVim/SpaceVim

vim和nvim的传统配置在vim的教程中另外编写，不在这里进行赘述

```bash
# install vim
sudo apt-get install vim

# install nvim
# sudo apt-add-repository ppa:neovim-ppa/stable
# sudo apt-get update
sudo apt-get install neovim

# install the spacevim jump to the spaceVim doc
```

### Install Monitor

**Install** Resource Monitor for Linux Sys.
**Including**: Htop, Bottom, Zenith
then we will describe the usage and install method of it.

**reference**:

- [Top Terminal Based Monitoring Tools for Linux | ComputingForGeeks](https://computingforgeeks.com/top-terminal-based-monitoring-tools-for-linux/)
- [Zenith (reposhub.com)](https://reposhub.com/linux/miscellaneous/bvaisvil-zenith.html)
- [ClementTsang/bottom (github.com)](https://github.com/ClementTsang/bottom)
- [bvaisvil/zenith (github.com)](https://github.com/bvaisvil/zenith)

#### Htop

this is the easiest one, we can download it by default command.

```bash
sudo apt-get install htop
```

**usage**

`htop`

#### Bottom

we need to use curl download the packages, then install it like below:

ubuntu/debian:

```bash
curl -s https://api.github.com/repos/ClementTsang/bottom/releases/latest | grep browser_download_url | grep amd64.deb | cut -d '"' -f 4 | wget -qi -

sudo apt install ./bottom*.deb
```

**usage**:
`btm`

#### Zenith

we need to install cargo/rust first, then we can download Zenith like Bottom,
but acturally we only need one of it.

ubuntu/debian:
This way is not supposed nvidia-GPUs.

```bash
# install the rust first
sudo apt-get install rustc

# download the package of Zenith
curl -s https://api.github.com/repos/bvaisvil/zenith/releases/latest | grep browser_download_url | grep linux | cut -d '"' -f 4 | wget -qi -

# unzip it and install
tar xvf zenith.linux.tgz

# change the mode of shell
chmod +x zenith
sudo mv zenith /usr/local/bin
```

If we want zenith show GPU infomation, we need to build it from the source code.
And we will discuss this later.(learn about build/make first)

```bash
placeholder
```

**usage**:
`zenith`

### Zsh and OhMyZsh 终端设置

[0xFFFF](https://0xffff.one/d/716)

[zsh & oh-my-zsh 的配置与使用](https://zhuanlan.zhihu.com/p/58073103)

[zsh、oh-my-zsh、tmux、vim](https://traceme.space/blog/page/6/zshoh-my-zshtmuxvimdocker/)

基于zsh和oh my zsh对命令行主题进行美化

```bash
# 安装zsh
 sudo apt-get install zsh
# 修改默认shell为zsh
 chsh -s /bin/zsh
 
# 安装oh-my-zsh
 sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
 
# 或者使用wget
 sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
 
# 或者使用git clone 结合镜像站使用下载较为稳定
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
```

如果我们需要将默认终端恢复bash：

```bash
 chsh -s /bin/bash root
# h或者尝试直接输入bash
```

#### 切换主题部分

除了第一个命令其他的都在文档中修改/添加

https://github.com/ohmyzsh/ohmyzsh/wiki/Themes 主题预览

```bash
# 切换主题等
 code ~/.zshrc
ZSH_THEME="tonotdo"
# （笔者比较喜欢这套主题，可自行选择，或者随机使用）
 setopt no_nomatch
# （在文档末尾添加，解决zsh语法与bash语法不太兼容的问题，更多请参考[1]）
 export TERM=xterm-256color
#（设置终端色彩模式，vim使用airline增强状态栏，需要此模式）
```

#### zsh插件安装

[oh my zsh插件安装](https://segmentfault.com/a/1190000039860436)；[zsh插件配置 ](https://www.jianshu.com/p/8a912dc8de57)

1. 安装语法高亮：zsh-syntax-highlighting

   通过命令的颜色来判断输入的指令是否是正确的

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

2. 安装自动补全：zsh-autosuggestions

   主要是基于之前的命令来进行不全

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

找到对应的安装位置，在对应的.zshrc中进行配置然后激活配置文件即可。

#### 出现的问题

没有conda指令

```bash
# 换用别的终端
conda init zsh
```

conda activate消失
解决办法：

```bash
# 保守方法，已测试 workflow如下
# 先将主题切换为bash
# 在vscode的默认启动项中将启动的terminal切换回bash
 chsh -s /bin/bash
# 卸载oh_my_zsh, and zsh
 sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/uninstall.sh)"
 apt-get remove zsh
# 进入portainer，在portainer的bash中执行
 conda init
# 之后在所有环境中都不需要再执行这个activate的操作了
```

但是好像在mobaxterm中还是需要手动激活一下，但是至少activate回来了

## Anaconda 安装

### 参考文档

[如何在 Ubuntu 20.04 上安装 Anaconda](https://cloud.tencent.com/developer/article/1649008)；[oh-my-zsh主题支持conda虚拟环境](https://www.lyytaw.com/%E6%9D%82%E9%A1%B9/oh-my-zsh%E4%B8%BB%E9%A2%98%E6%94%AF%E6%8C%81conda%E8%99%9A%E6%8B%9F%E7%8E%AF%E5%A2%83/#%E8%83%8C%E6%99%AF)；[oh-my-zsh主题显示conda环境名称](https://blog.csdn.net/zw__chen/article/details/100748928)

### 下载安装

找到最新的安装包版本：[Index of anaconda](https://repo.anaconda.com/archive/) 后选择对应的版本安装

```bash
wget -P /tmp https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh
```

可选）验证下载版本的正确性：

```bash
sha256sum /tmp/Anaconda3-2021.05-Linux-x86_64.sh
# 查看输出的哈希值和对应的archive上的值是一致的
```

安装anaconda

```bash
sh /tmp/Anaconda3-2021.05-Linux-x86_64.sh
# 按照intro应该会执行conda init 等等操作，如果没有我们可以自行执行
```

### 环境激活

```bash
# 假如当前的shell是zsh
bash
source ~/.bashrc
conda init zsh
# 退出bash回到zsh
source ~/.zshrc
```

### 关闭Conda的命令行提示

```shell
conda config --set changeps1 false
```

### Anaconda 查看添加删除

```shell
conda config --show-sources
```

## 注意事项

@Aiken 2020

本文档主要记录一些Linux下面遇到的问题解决方法：

### python环境无法识别

安装完linux以后在bash没法执行conda命令，以及识别不出conda中安装的环境，而从portainer中可以直接启动python的非对等偏差问题。

```bash
source  /opt/conda/bin/activate
conda activate base
```

应该是由于没有将conda的自启动加入docker中的自动运作中，所以需要自行对conda 命令进行启动。

**solve update：**

直接在portainer的terminal中执行如下命令即可一劳永逸

```bash
 conda init
```

### 删除Zsh后远程无法连接

由于设置zsh作为基本bash，导致问题的原因可能是接受ssh启动的bash 换成zsh了，而我们zsh已经卸载了，就无法修改。

解决方法，尝试从potainer控制台的console ，root登录基本的bash，在基本bash中将login shell 改成zsh。

参考链接：[LINK](https://www.v2ex.com/amp/t/270407?__cf_chl_jschl_tk__=6264f73af1e0c5f14959dfe3604b3da795b3d4da-1602866582-0-AUHrxUdAsZyuwjIUeBGnWQk2x9m6JknAuUFnv_qwxCjCjaoGV7HaIyGQK7SX0QYCHTb6ccqqxizj0GWSRT0gwCDPIh_0G41kPJ14qBcs8570f6hF1r86Lx3o1VkOSC3JXbNzrH6ybDKpmyPmZtPFnfRtPFabzNlgFjbqE8cV_BDenHLDsSBAkENttf13tiKG39tLcUdWcZXQfwVOmyLkoNajKXCqFXwAFSwXqHyW1egKxBQ1bkmCllJGtyBh9D0CD0VsRq6vjVpfeenxOc-1XEqCEPQ2ahzDWEMfNzfjnYcktOSWpkhnUFbqw0L1vss8Y9jG7uooSAxoGS1tgr_XfT022kedjZm1fVCd4AmwSGvo)

```bash
 vi /etc/passwd
# passwd文件中把shell 改回bin/bash 即可
```

### apt-get 找不到包

```bash
# 首先执行apt-get的更新
 sudo apt-get update
```

### apt-get /var/lib/dpkg/lock-frontend 

```bash
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/lib/dpkg/lock
sudo rm /var/cache/apt/archives/lock
```

不知道哪个真正起了作用，都试试把

### chsh: PAM: Authentication failure

```sh
code /etc/passwd
# 里面可能有一些配置出现了问题，包括 bin/bash 漏了前面的斜杠这种
```

### NVCC command not found

在安装CUDA后还是找不到命令的话，可以去以下地址找一下对应的cuda文件是否存在

```bash
ls -l /usr/local/cuda
# 如果存在的话，将cuda的路径导入到bashrc中
```

```ini
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
export PATH=/usr/local/cuda/bin:$PATH
```

