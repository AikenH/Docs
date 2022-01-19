# Shell Lang

@AikenHong 2021 This Doc is About shell Script
@Reference: [The Art of Command Line](https://github.com/jlevy/the-art-of-command-line/blob/master/README-zh.md)

脚本语法的文档

## 基本命令

执行`script.sh`的方式：

```bash
# powershell
# but this function will appear some error for git command
bash script.sh

# linux 
sh script.sh
```

`echo` Display A Line of Text


## 条件语句

按照`if`,`else`,`fi`来进行编写，同时`[]`中前后都需要有相应的空格

```bash
# enter the right dir 
cd _book

# using conditional rules to control the update actions
if [ -d ".git" ]; then
	echo "exist git files"
else
	git init 
	git remote add origin ..
	echo "add remote repo"
fi

```

[Linux-shell中$(( ))、$( )、``与${ }的区别](https://www.cnblogs.com/chengd/p/7803664.html)

## 特殊指令

```bash
g++ helloworld.cpp -o a
./a <input >output
```
