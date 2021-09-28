# VsCode Python Debug Launch.json 编写

@Aiken 2020

配置Launch.json 能够帮助我们更好的进行debug的操作。

有一些一些比较特别的文件名和相关编码。

## Debug Launch json

找到launch文件并打开

![image-20201014103517116](https://raw.githubusercontent.com/AikenH/md-image/master/img/image-20201014103517116.png)

自定义JSON：执行工作文件夹下的main.py进行调试

```json
{
    "name": "experiment",
    "type": "python",
    "request": "launch",
    "program": "${workspaceFolder}/main.py",
    "console": "integratedTerminal",
    "args": ["--data_path","${workspaceFolder}/data",
            "--mode","0","--resume","false"]
},
```

默认 JSON：执行当前文件

```json
{
    "name": "current file",
    "type": "python",
    "request": "launch",
    "program": "${file}",
    "console": "integratedTerminal"
}
```

## 特殊参数

${workspaceFolder} :指代当前运行目录

${file}:指代当前文件

## BTW TODO-Tree Setting Json

打开设置-打开json文件（设置右上角）

![image-20201014103748598](https://gitee.com/Aiken97/markdown-image/raw/master/img/20210911212625.png)

添加如下内容：（颜色和关键词可自定义）

```json
"todo-tree.tree.showScanModeButton": true,
    "todo-tree.highlights.enabled": true,
    "todo-tree.highlights.defaultHighlight": {
        "type": "text and comment",
    },
    "todo-tree.highlights.customHighlight": {
        "TODO": {
            "foreground": "#2f3542",
            "background": "#f6b93b",
            "iconColour": "#f39c12",
            "icon": "issue-opened",
            "type": "line"
        },
        "FIXME": {
            "foreground": "#2f3542",
            "background": "#e55039",
            "iconColour": "#e55039",
            "icon": "flame",
            "type": "line"
        },
        "NOTE": {
            "foreground": "#2f3542",
            "background": "#9980FA",
            "iconColour": "#6c5ce7",
            "icon": "eye",
            "type": "line"
        },
        "RECORD": {
            "foreground": "#2f3542",
            "background": "#7bed9f",
            "iconColour": "#2ed573",
            "icon": "info",
            "type": "line"
        }
    },
    "todo-tree.general.tags": [
        "TODO",
        "FIXME",
        "NOTE",
        "RECORD"
    ],
```

