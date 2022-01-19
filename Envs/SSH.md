# SSH 系列相关操作

@Aiken 2021

主要介绍ssh服务在以下的几个方面（windows，linux）的使用情况：远程服务器连接（22），git&github（gitee），vscode免密登录。

## ssh-key

[GITHUB关于SSH的教程](https://docs.github.com/en/github/authenticating-to-github/checking-for-existing-ssh-keys) 👈可以直接切换成中文模式的

**查看是否已存在**

```bash
$ ls -al ~/.ssh
```

**初始化 / 生成 ssh key **

```bash
// github 推荐，优先度从上到下递减
$ ssh-keygen -t ed25519 -C "your_email@example.com"
// if not support 
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
// tradition
$ ssh-keygen -t rsa -C "chenlangl@outlook.com"

```

**将ssh添加到github的个人权限界面中**

**免密登录**

在github的教程中也有另一种方式来实现免密登录，好像是ssh-agent的方式安全的保存密码。

## Linux 开放远程权限

[设置sshd配置文件](http://frantic1048.logdown.com/posts/291498-resolve-the-ssh-password-is-correct-but-was-refused-connection) | [允许passwd登录root](https://www.cnblogs.com/zqifa/p/linux-ssh-2.html)

## Git&Github

官方文档介绍的一些权限错误的地址：https://docs.github.com/en/github/authenticating-to-github/error-permission-denied-publickey

初始化git的用户配置，可以按照电脑id来进行命名其实区分起来还是好弄一些。

```bash
$ git config --global user.name "YOURNAME"
$ git config --global user.email YOUEMAILADRESS
// 查看相关的配置信息
$ git config --list
```

将本机的ssh公钥(public)放到GITHUB账户下的ssh管理地址，执行测试

```bash
$ ssh -T git@github.com
```

没有问题的话就可以直接进行clone，之类的git操作了

```bash
// 小trick，不拉取历史的commit
$ git clone --depth=1 REPO_ADRESS
```

## ssh 免密认证

windows(Local) - Linux(Services) :[Link1 Pro](https://blog.frytea.com/archives/409/)

实际上不光是VsCode，可以在本机上通过ssh服务免密登录服务器了，这一块好像可以通过公钥和私钥两种方式来做，在这里我们首先使用公钥来测试成功。

具体的操作如下：

```bash
$ cd /root/.ssh
// 创建authorized_kes
$ touch authorized_kes
// 在其中填入我们需要远程登录的服务器的ssh pub key，在这里就是windows本机的。
// 修改权限
$ sudo) chmod 600 authorized_kes
$ sudo) chmod 700 ~/.ssh/
```

**然后检查密钥登录的功能是否开启**

```bash
// 修改相应的ssh配置文件
$ code ./etc/ssh/sshd_config
```

查看其中的这两项配置是否打开：

```
RSAAuthentication yes
PubkeyAuthentication yes
```

可以禁用密码登录，但是这样的方式可能会导致后面挂了以后直接GG，所以慎重。

**重启服务**

```bash
$ service ssh restart
```
