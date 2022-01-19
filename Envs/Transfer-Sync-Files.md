# 文件传输和同步

@aikenhong 2022

当我们需要在Server之间进行，或者Server和WSL之间进行文件的传输，以及文件夹的同步的时候，如果要打开Xftp之类的软件进行，有繁琐的操作中转，或者说目录较为庞杂的时候，也显得有些麻烦。

于是我们可能希望使用脚本，来实现更便捷，同时也能设置定时功能，使得操作简单便捷，经过简单的调研，我们目前尝试使用以下几种方法，并取得了成功。

## Rsync 同步目录

rsync是借助ssh服务进行的文件传输，为了使用起来方便，我们首先需要配置免密登录，在服务器之间传输SSH密钥，参考[[Envs/SSH]]

此后我们便可以编写同步脚本来同步远程的目录和本地目录，当然也可以执行反向的命令，

```bash
rsync -azP --delete -e 'ssh -p port' --progress --stats --exclude "big Files or sth" user@ip:source_path target_path >transfer.log
```

根据progress和stats我们记录传输过程中的日志，并输出到transfer.log，同时使用exclude排除大文件，避免传输过慢。

>a: 归档文件模式（保留文件的时间戳等），保括了r的递归
>z: 使用压缩文件传输
>P: 支持断点续传
>delete: 会删除目标文件中多出来的东西，保持同步，使得成为远程的镜像，但是有时候我们可能不需要这点，避免同步损毁

参考：

- [Ubuntu使用Rsync远程备份](https://cloud.tencent.com/developer/article/1490094?from=article.detail.1813628)
- [阮一峰的rsync详细讲解](https://www.ruanyifeng.com/blog/2020/08/rsync.html)


## SCP传输特定文件

Linux scp文件传输命令用于Linux之间复制文件和目录，全称“secure copy”，基于SSH进行的安全的远程文件拷贝命令

```bash
model='local file'
scp -P port $model user@remote_ip:remote_folder
```

[菜鸟教程scp参数介绍](https://www.runoob.com/linux/linux-comm-scp.html)

## Crontab定时执行脚本

实际上本篇章应该在后续移动到Linux笔记中，是一个定期执行程序的命令，我们可以通过这个命令来定期执行我们的脚本

```bash
crontab -l 
crontab -e
sudo nvim /etc/rsyslog.d/50-default.conf 开启cron.log

重启相关服务
sudo service rsyslog restart
sudo service cron restart
```

编辑定时设置：

```bash
30 10 * * * path/file.sh >> logfile.log
```

修改要调用的sh文件的权限

```bash
sudo chmod 777 file.sh 
```

[菜鸟教程](https://www.runoob.com/linux/linux-comm-crontab.html)