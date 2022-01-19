# Git Workflow

@Aiken 2020(2021)

## Init Git

包含ssh的详细指令在ssh的文档中，这边只介绍设置完这一系列操作之后的git初始化，主要是初始化ssh，并将私钥放到github或者gitee的账户中。
建议用Pc的名字来做标识

```shell
git config --global user.name "YOURNAME"
git config --global user.email YOUEMAILADRESS

# 查看相关的配置信息
git config --list
```

### Git&Github

官方文档介绍的一些权限错误的地址：<https://docs.github.com/en/github/authenticating-to-github/error-permission-denied-publickey>

将本机的ssh公钥(public)放到GITHUB账户下的ssh管理地址，执行测试

```shell
ssh -T git@github.com
```

没有问题的话就可以直接进行clone，之类的git操作了

```shell
# 小trick，不拉取历史的commit
git clone --depth=1 REPO_ADRESS
```

### Gitignore

1. 对文档创建相应的忽略文件，然后在里面编写要忽略的文件，文件夹就可以了，特殊的通配符多了解。
2. 通过VsCode的插件或GitHub的Doc对不同语言进行初始化配置

```shell
touch.gitignore
```

[Git忽略提交规则 - .gitignore配置运维总结](https://www.cnblogs.com/kevingrace/p/5690241.html)

## Git 常用命令

| 普通           | command                          | 分支          | command                  |
| -------------- | -------------------------------- | ------------- | ------------------------ |
| 创建本地repo   | git init                         | 创建/显示分支 | git branch <name>        |
| 工作区状态     | git status                       | 切换分支      | git checkout <branch>    |
| 添加到暂存区   | git add <file>/.                 | 创建&切换     | git checkout -b <name>   |
| 暂存区到本地   | git commit -m ‘mesg’             | 合并分支      | git merge <branch>       |
| 日志           | git log (–oneline)               | 删除分支      | git branch -d            |
| 拉取远程库     | git pull                         | 推送本地分支  | git push origin <branch> |
| 克隆远程库     | git clone                        |               |                          |
| **撤销**       |                                  | **标签**      |                          |
| 撤销工作区修改 | git checkout – <file-name>       | 创建标签      | git tag <tag-name>       |
| 撤销暂存区修改 | git reset HEAD <file-name>       | 显示所有标签  | git tag                  |
| 撤销本地库修改 | git reset –hard <commitID>       | 删除标签      | git tag -d <tag>         |
| **远程**       |                                  | **储藏**      | ·                        |
| 同步本地库和   | git remote add origin xx@y<repo> | 保存现场      | git stash                |
| 远程库         | git push -u origin master        | 恢复现场      | git stash pop            |

### 远程操作

推送本地的分支到远程的指定分支

  ```shell
git push origin local:remote
# 冒号前本地，冒号后远程
git pull origin remote:local
  ```

git fetch: 实际上pull = fetch + merge

  ```shell
git fetch
git log -p FETCH_HEAD
git merge FETCH_HEAD
  ```

### 暂存区处理

清除暂存区某个文件的指令（通常是为了修改.gitignore）的时候执行

```shell
git rm -r --cache filename
```

看暂存区有什么文件

```shell
git ls-files
```

### commit 处理

撤销commit

```shell
git reset --soft HEAD^  # 撤销当前commit
git commit --amend      # 重写当前commit
```

合并commit rebase：

```shell
# 查看多个commit的hash值
git log

# 找到需要合并的最早commit的上一个的ID
git rebase -i <ID>

# 修改pick squre状态合并commit
```

## Commit Standard

commit message 格式：
$$
Type(scope):subject
$$

- **Type**：说明git commit的类别，限定标记类型
- **Scope**：用于说明影响的范围，非必须
- **Subject：**简短描述，建议使用中文可以更清楚

Type类型限定表格

| TYPE     | 描述                | TYPE   | 描述                    |
| -------- | ------------------- | ------ | ----------------------- |
| feat     | 新功能              | Fix/to | 修复bug（to只产生diff） |
| docs     | 文档                | style  | 样式（不影响代码运行）  |
| refactor | 重构                | perf   | 优化（性能和体验）      |
| test     | 增加测试模块        | chore  | 工具变动                |
| revert   | 返回到上个版本      | merge  | 代码合并                |
| sync     | 同步主线或分支的bug |        |                         |

### Git Rebase

通过rebase命令来进行merge，保持remote和local的commit整洁有效

## Bug Fixed

### 大文件

这一部分写的有点小瑕疵，到时候就看超链接

[郑宇](https://www.zhihu.com/question/29769130/answer/315745139)；主要是要将大文件排除追踪，在commit之前都还是比较好解决的，但是如果已经提交上去了就稍微比较麻烦，尝试将其中的大文件删掉。

```shell
# 1. 运行gc，生成pack文件`–prune = now` 表示对所有的文件都做修剪
git gc --prune=now

# 2. 找出最大的k个文件，以3为例
git verify -pack -v .git/objects/pack/*.idx |sort -k -3 -n |tail -3

# bug: cannot open ///bad ..
# 可能是由于地址出错了，修改地址，如下是查看地址的代码
find .git/objects/ -type -f

# 3. 查看那些大文件究竟是谁，按照上一步输出的hash value 进行搜索，（不用全长）
git rev-list --objects --all |grep <hashvalue>

# 4. 移除对该文件的追踪引用
git filter-branch --force --index-filter "git rm --cache --ignore-unmatch '<FILENAME HERER>'" --prune-empty --tag-name-filter cat -- --all

# 5. 进行repack
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now

# 6. 查看pack的空间使用情况
git count-objects -v

# 7. 强制推送重构大文件
git push origin local-b:remote-b --force
```

### openssl error 10054

```shell
 git config --global http.postBuffer 524288000
```

### time out port443

just wait for some time，应该是代理的问题，不行就使用国行版github把

### server certificate verification failed. CAfile

使用`github.com.cnpmjs.org`国内镜像站的时候，可能会出现权限的问题，这种情况下就要对git的证书验证命令做调整，有两种策略，执行其中一种：

```bash
git config --global http.sshverify false
```

```bash
# carry out in the 
export GIT_SSL_NO_VERIFY=1
```

