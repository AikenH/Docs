# Windows 常用操作

@AikenHong 2020

This document is about windows tips and powershell.

## WSL

Windows Subsystem Linux 部署Linux环境在Windows中，同时通过`/mnt`和Windows的文件系统进行交互和链接，在这种情况下需要另外设置包括`ssh`，`conda`等等环境，这些环境上与主机并不互通。

在Win11中的WSL2已经支持的相应主机的`CUDA`使用，所以如果要支持GPU的`Pytorch`，直接按照官网中的方法进行安装就好了。

### Install

首先启用WIndows的虚拟机功能；

具体的安装方法（两种）：

1. 在Windows Store中安装相应的发行版

2. 命令行方法：新版本的方法会默认下载最新的Linux内核（Ubuntu），

   ```powershell
   wsl --install
   
   # 列出对应的发行版
   wsl -l -o
   
   # 选择相应的发行版进行安装
   wsl --install -d <Distribution Name>
   
   # 如果当前的WSL是1版本，更新到2
   wsl -l -v
   wsl --set-default-version 2
   ```

WSL安装完后Terminal中应该会自动出现相应的配置，如果没有出现可以按照下面的JSON进行配置

### Mount And Move

WSL的默认存储路径：`%LOCALAPPDATA%/packages/c......./local_state`

修改WSL的默认存储路径，将磁盘挂载在别的地方

```powershell
# 关闭wsl服务
wsl --shutdown

# 查看关闭状态
wsl -l -v

# 导出wsl2 system； docker-desktop & docker-desktop-data
# 导出系统 wsl --export <DistroName> <PathToTarArchive>
wsl --export Ubuntu-20.04 E:\WSLWorkspace\ubuntu.tar

# 删除（注销）系统
wsl --unregister Ubuntu-20.04
# 导入系统到指定的新位置(使用新路径导入新系统)
wsl --import Ubuntu-20.04 E:\WSLWorkspace E:\WSLWorkspace\ubuntu.tar

# 启动WSL2服务（这里在terminal中会出现两个ubuntu的unid，把原本的第一个给注释掉才行）
# 设置默认wsl2用户
ubuntu2004.exe config --default-user xxx

# 删除多余的所有tar，over
```



### SSH

[wsl2启用SSH](https://www.jianshu.com/p/3e2b7252b4b8)，ssh功能应该默认是启用的，如果ssh没有启用的话

```sh
vim /etc/ssh/sshd_config
```

修改如下的几个配置

>Port = 22 去掉这行的#，代表启用端口号22
>ListenAddress 0.0.0.0 去掉这行的#，代表监听所有地址
>PasswordAuthentication yes，将这行的no改成yes，代表支持账号密码形式的登录

重启服务

```shell
sudo service ssh restart
```

此时还不能支持root用户密码登录
默认情况下，root用户只支持用RSA登录，但是可以修改配置的
切换到root用户打开SSH的配置文件

找到行`PermitRootLogin prohibit-password`保留这行的#，这意味着：允许root登录，但是禁止root用密码登录，所以这行要注释掉。
 需要添加一行:

```powershell
PermitRootLogin yes
```

剩下的其余配置按照`Linux`文档进行文件的配置

### SETTING

WSL在Windows Terminal的启动目录设置

```json
//wsl$/Ubuntu-20.04/home/aikenhong
``````
## PowerShell

shift+右键: 在此处打开powershell.

[PowerShell ](https://github.com/PowerShell/PowerShell/releases)，这里的PowerShell和windows的已经不是同一个东西了，可能要更先进一些，通过`msi`进行安装，安装完后重启terminal就会自动的添加配置，后续的配置在这个new shell中进行会更好一些



### Window Terminal

**Install** ：Windows Store

**添加Terminal到右键菜单**：

参考：[Windows Terminal 完美配置 ](https://zhuanlan.zhihu.com/p/137595941)中的右键菜单部分：[Install/uninstall scripts for Windows Terminal context menu items ](https://github.com/lextm/windowsterminal-shell/)

注意，这里涉及到注册表修改的操作，所以我们需要在修改注册表之间建立注册表还原点。

**Basic Config**：

新版本的Terminal中大部分的配置都已经有了UI了，配置起来还是比较方便的，其实主要的配置直接在设置面板里设置就可以了。这里以早期版本的配置文件设置为例：

```json
{
    "$schema": "https://aka.ms/terminal-profiles-schema",
    "actions":
    [
        {
            "command":
            {
                "action": "copy",
                "singleLine": false
            },
            "keys": "ctrl+c"
        },
        {
            "command": "find",
            "keys": "ctrl+shift+f"
        },
        {
            "command": "paste",
            "keys": "ctrl+v"
        },
        {
            "command":
            {
                "action": "splitPane",
                "split": "auto",
                "splitMode": "duplicate"
            },
            "keys": "alt+shift+d"
        }
    ],
    "alwaysShowTabs": true,
    "copyFormatting": "rtf",
    "copyOnSelect": false,
    "defaultProfile": "{07b52e3e-de2c-5db4-bd2d-ba144ed6c273}",
    "initialCols": 130,
    "initialRows": 35,
    "launchMode": "default",
    "profiles":
    {
        "defaults":
        {
            "acrylicOpacity": 0.69999999999999996,
            "closeOnExit": "graceful",
            "colorScheme": "AdventureTime",
            "font":
            {
                "face": "FiraCode Nerd Font"
            },
            "historySize": 9001,
            "padding": "5, 5, 20, 25",
            "snapOnInput": true,
            "startingDirectory": ".",
            "useAcrylic": true
        },
        "list":
        [
            {
                "backgroundImage": "C:\\Users\\Aiken\\Pictures\\Camera Roll\\a560083febb425e04ba0a86a7851c51dc2b417a4.png",
                "backgroundImageOpacity": 0.26000000000000001,
                "colorScheme": "purplepeter",
                "commandline": "powershell.exe",
                "font":
                {
                    "face": "FiraCode Nerd Font Mono Retina"
                },
                "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
                "hidden": false,
                "name": "Windows PowerShell"
            },
            {
                "commandline": "cmd.exe",
                "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
                "hidden": false,
                "name": "CMD"
            },
            {
                "guid": "{b453ae62-4e3d-5e58-b989-0a998ec441b8}",
                "hidden": true,
                "name": "Azure Cloud Shell",
                "source": "Windows.Terminal.Azure"
            },
            {
                "colorScheme": "Banana Blueberry",
                "commandline": "ssh root@202.117.43.196 -p 23076",
                "guid": "{44257ed0-90f8-41a1-bad0-2c637012ce40}",
                "hidden": false,
                "icon": "ms-appx:///ProfileIcons/{9acb9455-ca41-5af7-950f-6bca1bc9722f}.png",
                "name": "202.117.43.196",
                "startingDirectory": "."
            },
            {
                "acrylicOpacity": 0.68999999999999995,
                "antialiasingMode": "cleartype",
                "backgroundImage": "desktopWallpaper",
                "backgroundImageOpacity": 0.20000000000000001,
                "colorScheme": "purplepeter",
                "commandline": "wsl.exe ~",
                "cursorShape": "underscore",
                "experimental.retroTerminalEffect": false,
                "font":
                {
                    "face": "FiraCode Nerd Font"
                },
                "guid": "{07b52e3e-de2c-5db4-bd2d-ba144ed6c273}",
                "hidden": false,
                "intenseTextStyle": "all",
                "name": "Linux20.04",
                "padding": "10",
                "source": "Windows.Terminal.Wsl",
                "startingDirectory": null,
                "tabTitle": null
            }
        ]
    },
    "schemes":
    [
        {
            "background": "#1F1D45",
            "black": "#050404",
            "blue": "#0F4AC6",
            "brightBlack": "#4E7CBF",
            "brightBlue": "#1997C6",
            "brightCyan": "#C8FAF4",
            "brightGreen": "#9EFF6E",
            "brightPurple": "#9B5953",
            "brightRed": "#FC5F5A",
            "brightWhite": "#F6F5FB",
            "brightYellow": "#EFC11A",
            "cursorColor": "#FFFFFF",
            "cyan": "#70A598",
            "foreground": "#F8DCC0",
            "green": "#4AB118",
            "name": "AdventureTime",
            "purple": "#665993",
            "red": "#BD0013",
            "selectionBackground": "#FFFFFF",
            "white": "#F8DCC0",
            "yellow": "#E7741E"
        },
    ],
    "showTabsInTitlebar": true,
    "tabWidthMode": "titleLength",
    "theme": "dark",
    "windowingBehavior": "useAnyExisting"
}
```



### Posh and Oh-My-Posh

主要步骤可以分为一下几点，安装字体，安装`Posh`，安装&设置`oh-my-posh`

参考链接：

1. 个人的知乎回答

2. [Style your Windows terminal](https://medium.com/@hjgraca/style-your-windows-terminal-and-wsl2-like-a-pro-9a2e1ad4c9d0)
3. [Windows Terminal 完美配置 ](https://zhuanlan.zhihu.com/p/137595941)
4. [Upgrading | Oh My Posh](https://ohmyposh.dev/docs/upgrading)

字体安装与下载：按照[链接](https://www.nerdfonts.com/font-downloads)下载安装就行了

安装PowerShell插件：

```powershell
# 后面的这些User的限制倒是不需要
# 安装PSReadLine
Install-Module -Name PSReadLine  -Scope CurrentUser
# 如果上面安装出现问题, 可以尝试下面的
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck

# 安装PSR包，让命令行更好用，类似ZSH
Install-Module -Name PSReadLine
Install-Module -Name PSReadLine -Scope CurrentUser

# 安装Posh-git包，让git更好用
Install-Module -Name posh-git
Install-Module -Name posh-git -Scope CurrentUser
```

查看现存主题：

```powershell
Get-PoshThemes
# 设置主题
Set-PoshPrompt -Theme half-life
```

设置Terminal中的启动参数

```powershell
code $PROFILE
```

并设置成如下的形式

```powershell
# 导入包
Import-Module posh-git
Import-Module oh-my-posh
Import-Module PSReadLine
# 设置主题
Set-PoshPrompt -Theme spaceship

# ================psreadline setting
# 设置预测文本来源为历史记录
Set-PSReadLineOption -PredictionSource History
# 每次回溯输入历史，光标定位于输入内容末尾
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
# 设置 Tab 为菜单补全和 Intellisense
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
# 设置 Ctrl+d 为退出 PowerShell
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit
# 设置 Ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo
# 设置向上键为后向搜索历史记录
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
# 设置向下键为前向搜索历史纪录
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
```



### Findstr/Find

```powershell
# this command is like grep in Linux
Common-u-want-to-carry-out | findStr "String"
# for example
conda list | Select-String ("matplot" , "pillow", "scipy", "tensorboard")
```

### Generate GUID

this command can generate the only GUID

```powershell
new-guid
```

## PANBAIDU

百度网盘的网页版倍速播放的技巧：

```html
videojs.getPlayers("video-player").html5player.tech_.setPlaybackRate(2)
```

## Office AutoSave

- 首先通过设置（选项）界面找到自动保存的asd文件的地址
- 在信息-管理文档中选择ASD进行对文档的恢复
