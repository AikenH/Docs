# Read Local Data

@Aiken  2021 

对于各种形式的标记文档和数据集的处理进行一个整合，还有一些python中的相关模块（比比如glob，后续可能会迁移到别的文档中），主要包括：yaml，json，csv，xml，这些可拓展的标记语言.

**TODO：**

- [ ] csv,xml：这一部分可以看一下吉仲师兄那边是怎么存和取文件的，继承一下代码减少我这一部分的工作量
- [ ] 按照csv文件对数据集进行本地的文件夹切分。实际上很多数据集，像mini-imageNet这类的是需要我们下载下来之后按照csv文件对训练集和测试集进行切分的
- [ ] 使用sklearn对完整的未切分数据进行切分。



## Python: Glob

文件操作相关模块，用于简单的路径匹配的模块，用来查找路径中的相关文件，基本的正则匹配规则如下：

> “*”: 匹配0哥或多个字符
>
> “?” : 匹配单个字符
>
> “[ ]”: 匹配指定范围内的字符,如[0-9]匹配所有的数字

### glob.glob:

**返回所有匹配的路径列表**,只有一个参数pathname,定一乐文件路径的匹配规则,可以是绝对路径或者是相对路径,具体的使用可以参考如下的方式:

```python
for xmlpath in glob.glob('media/all/DATAPART/' + "*")
# xmlpath 遍历文件夹下的所有文件和文件夹

for xmlpath in glob.glob(xmlpath + "/*/*")
# xmlpath 遍历文件夹下所有文件夹中的文件夹中的文件:按照层数自由设定

img_path = sorted(glob.glob(os.path.join(images, '*.npy')))
# 遍历文件夹下的所有npy文件,说实话感觉这个怪离谱的,晚点试一下

import glob 
print(glob.glob(r"E:/imgdir/*/*.jpg"))

```

### glob.iglob()

**获取一个可遍历对象**使用它可以逐个获取匹配的文件路径名:

- glob:一次获取全部
- iglob:逐个匹配路径获取.

## Python：pickle

palceholder

## YAML

YAML是一种标记语言，可以通过YAML定义超参数，然后从外部引入，所以常用来作为一些特定的config，具体的用发和用途可以这样理解：

- 当我们使用不同的backbone module的时候，我们可能对于超参数等等的一系列配置是不恒定的，所以使用config文件去配置的时候，当我们每次切换，我们就只需要读取不同的config文件就行了。
- 实际上就是argparse的一种替代

所以本文档聚焦于如何在`python/cpp`中读取yaml（以及cpp补充相应的数据类型）

### 写在前面

基本的语法什么的很好搜索，随便百度一下就行了

- [offical site](https://yaml.org/)
- [菜鸟入门教程](https://www.runoob.com/w3cnote/yaml-intro.html)

实际上大部分都是使用缩进去控制的，例子👇，很明显可以看出对应的元素关系，包括字典，boolean，float等其他的类型。

```yaml
# default num_head = 2
criterions:
  PerformanceLoss:
    def_file: ./loss/SoftmaxLoss.py
    loss_params: {}
    optim_params: null
    weight: 1.0
last: false
# apply incremental pca to remove main components
apply_ipca: false
num_components: 512

networks:
  classifier:
    def_file: ./models/CausalNormClassifier.py
    optim_params: {lr: 0.2, momentum: 0.9, weight_decay: 0.0005}
    scheduler_params: {coslr: true, endlr: 0.0, gamma: 0.1, step_size: 30}
    params: {dataset: ImageNet_LT, feat_dim: 2048, num_classes: 1000, stage1_weights: false, use_effect: true, num_head: 2, tau: 16.0, alpha: 3.0, gamma: 0.03125}
shuffle: false
training_opt:
  backbone: resnext50
  batch_size: 512
  dataset: ImageNet_LT
  display_step: 10
```



### YAML-Python

下面直接给出一个例子，基本就按照这个格式去编写就没什么问题了。

```python
import yaml
import os
# 通常使用这种方式去打开文件并进行读取，这里实际上涉及到Python的IO操作
with open(args.cfg) as f:
	config = yaml.load(f)
# 为了保证编写的一致性和与argparse的一致性使用（整合同个用途或者同个类型的数据），通常会编写update函数将两种类型中的参数整合起来
config = update(config,args)
# 然后用字典的方式将config（yaml）中的每一部分要素按照命名读取出来
# 原则是：让读取出来的数据的堆叠层数不要太多，尽量就是一个dict或者一个list把

def update(config,args):
    # 在这里可以只提取出args中感兴趣的要素，也可以递归调用args中的所有参数
    for k,v in args.items():
        config[k] = v
    # or write down some interest elements only
    config['element'] = 'specific value'
    
```



### YAML的写入



## JSON

json是一种存储和交换文本的语法，类似XML。[Link1](https://blog.csdn.net/jmu201521121021/article/details/100996404)

> 经纬师兄这块是按照coco的json格式去整理的文档，同时数据的存储用的是npy,npz

```json
{
"employees": [
{ "firstName":"Bill" , "lastName":"Gates" },
{ "firstName":"George" , "lastName":"Bush" },
{ "firstName":"Thomas" , "lastName":"Carter" }]
}
```

可以看VsCode中的配置文件实际上也是这种格式的：

```json
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
        }
},
```

读取的时候实际上也是和键值对一样的读取,用dict,

### Json-Python

**首先给出一个Json和python的类型对照表**

| Python                             | Json   |
| ---------------------------------- | ------ |
| dict                               | object |
| list,tuple                         | array  |
| str                                | string |
| int float int-&float-derived Enums | number |
| True                               | true   |
| False                              | false  |
| None                               | null   |

Python中Json的主要导入和输出的方式主要是使用`dumps`和`loads`将python对象编写成json字符串,以及对json字符串在python中编码

**dumps**

```python
import json
data = [ { 'a' : 1, 'b' : 2, 'c' : 3, 'd' : 4, 'e' : 5 } ]
data2 = json.dumps(data)
print(data2)
# 使用参数让json数据格式化输出
#!/usr/bin/python

data2 = json.dumps({'a': 'Runoob', 'b': 7}, sort_keys=True, indent=4, separators=(',', ': '))
print(data2)
```

**loads**

```python
#!/usr/bin/python
import json
jsonData = '{"a":1,"b":2,"c":3,"d":4,"e":5}';
text = json.loads(jsonData)
print(text)
```

载入文件的示例:

```python
with open("../config/record.json",'r') as load_f:
    load_dict = json.load(load_f)
    print(load_dict)
load_dict['smallberg'] = [8200,{1:[['Python',81],['shirt',300]]}]
print(load_dict)

with open("../config/record.json","w") as dump_f:
    json.dump(load_dict,dump_f)
```

## XML

参考一下吉仲师兄的数据处理文件,按照该文件进行数据处理和xml python 读取情景的学习。



## CSV

[python3：csv的读写_katyusha1的博客-CSDN博客](https://blog.csdn.net/katyusha1/article/details/81606175)

### write

好像直接修改文件后缀进行编写的编码方式会出现一些离奇的问题，所以最好还是调用代码来写入`csv`



### read

需要注意的参数是 `quotechar`：说明：delimiter是分隔符，quotechar是引用符，当一段话中出现分隔符的时候，用引用符将这句话括起来，就能排除歧义。

首先按照row进行文件的读取，这应该回事比较常见的那种类型。

```python
import csv 
with open('test.csv'，newline = '') as f:
	f_csv = f.reader(f,delimiter=default,quotechar = default)
	for row in f_csv:
		print(row)
# 这种格式读取出来的数据会有一个存放对应的=label，然后剩下的就是每一行数据的每一个
# 可以按照这种方式去根据index 索引对应的数据
```

> [‘class’,‘name’,’sex’,...]
>
> [‘1’,‘xiaoming’，‘male’,...]
>
> [‘1’,‘xiaohong’，‘male’,...]

按照上面的很容易知道，只读取指定的列就是通过即可

```c++
for row in f_csv:
	print(row[i])
```

