---
layout: post
title: PicBed for Upload
---

<center>路漫漫其修远兮，吾将上下而求索<br>The road ahead will be long ,Our climb will be steep. </center>

# PicBed

@Aiken 2020 first write，2021 modify

Mainly using picgo-core(command line) to setting picbed，and we can update the setting method

## Github

- [使用PicGo-Core（command line）设置github图床，自动转义url](#Pic-Bed)
- [插入自动复制图片，使用git上传github](#Git)

### 基本部署

1. 在偏好设置中的图像，进行如下设置👇： 下载或更新PicGo-Cord(command line)

![image-20200512160643588](https://raw.githubusercontent.com/AikenH/md-image/master/img/image-20200512160643588.png)

2. 接着去Github中建立一个Repo：UserName/RepoName，用以存放图片（Public），简单的用readme初始建立即可。

3. 在Github的setting - developer setting-personal access tokens中新建token，指定简单的repo权限，并记录个人的token（只显示一次）
   **Attention：** 忘记记录的话，在token中也是通过update token（好像是这个名，获取新的值的）

4. 用Typora打开配置文件设置，或者使用命令行进行配置

   ```json
   {
       "picBed": {
           "github": {
             "repo": "UserName/RepoName",
             "token": "your github token here",
             "path": "img/",
             "customUrl": "https://raw.githubusercontent.com/UserName/RepoName/master",
             "branch": "master"
           },
           "current": "github",
           "uploader": "github"
         },
         "picgoPlugins": {}
   }
   ```

5. 点击验证图片上传选项，进行测试，成功即可

### 存在问题

用Github做图床的话，上传不是十分的稳定（可能需要依赖科学上网技术。请八仙过海，各显神通）。可以用其他的服务器作图床，大体过程应该也差不多，后续个人有更换的话在进行补充。

1. 在其他的pc上可以使用相同的token进行复用，但是在进行测试的时候要记得将repo中的两张测试图片删除，不然可能会导致验证失败的问题。

## Gitee

因为gitee是国内的github，服务器比较稳定，所以我们也可以使用gitee作为我们更为稳定的图床；

两个链接合起来才是好用的，都有一些冗余：

- [Typora+picgo-core+gitee](https://zhuanlan.zhihu.com/p/145960692)
- [PicGo-core+Gitee+Typora](https://blog.csdn.net/weixin_42230956/article/details/111349889)

### gitee基本部署

- 安装Node，npm；

- 安装picgo-core的命令行命令：

  ```shell
  npm install picgo -g
  ```
  
- 安装gitee的插件：

  ```shell
  picgo install super-prefix
  picgo install gitee-uploader
  ```

### 配置Gitee Repo

- 初始化一个repo，保存URL中的User/repo，不要轻信标题，因为有昵称机制。

- 在个人资料中初始化个人的Token，勾选`projects`选项即可;

### 设置配置文件

基于picgo的命令，会自动的更新Json文件，我们不许需要

```shell
picgo set uploader
# up to the command hint, we input those messages
1.按上下键找到gitee，回车    
2.repo：用户名/仓库名 （打开自己的仓库，浏览器里的网址username/reponame）    
3.token：刚才生成的token    
4.path:路径，写仓库的名字就是reponame    
5.custompath:不用填，回车   
6.customURL:不用填，回车    
# finish setting process
picgo use uploader
```
