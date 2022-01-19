# Code Rules
@AikenHong 2021-\

实际上可以参考[Google 开源项目风格指南](https://zh-google-styleguide.readthedocs.io/en/latest/)，从中摘取自己需要格外注意的部分，Take a Note

一些自己的编程约束规定，基本的规则写在最前面，将语言特有的规则用章节的方式分开编撰，首先通用的部分主要包括：
- 命名规范分为两个部分
	- 文件名
	- 变量，函数，类别名
- 设计思想
	- 面向对象
	- 客制化程度高（泛化性强）
	- 文件关联（Like Import）
- 安全性
	- 对必要的条件做约束如`assert`和`raise`，进行错误检查
- Sync
	- Git使用同步和提交的规范 -> [Git](Envs/GitGithub.com)

后续会对上述的内容进行补充，首先按照这样的大纲进行后续规则的整理和分析。统一化自己的代码约束，写出好看好读的代码。

## Chapter1 Paradigm

对通用范式的归纳和整理，这一部分应该是该Blog的主要组成部分，基于这些规则来写出一个统一的，好看的，好读的，好用的代码，是我们的目的。

### Names

@reference：python命名规范


| TYPE      | RULEs            | EXAMS                 |
| --------- | ---------------- | --------------------- |
| Class     | CapWords         | class DataLoader()    |
| Constant  | CAPS             | HYPER                 |
| Exception | CapWords         | Exception             |
| Others    | loweronly        | def func()            |
|           | lower_with_under | def label_generator() |          |                  |                       |

属于是除了几个特别的需要首字母大写或者全部大写之外，都是小写加横杠了。

在对文件的命名规范进行整理之前，首先要对对应的模块，包，库的定义有一个比较清除的认知

| File    | RULES            | EXAMS        |
| ------- | ---------------- | ------------ |
| Module  | lower_with_under | resnet_18.py |
| Package | CapWords         | Model        | 
| Lib     |                  |              |


> 1.  所谓”内部(Internal)”表示仅模块内可用, 或者, 在类内是保护或私有的.  
> 2. 用单下划线_开头表示模块变量或函数是protected的(使用from module import 时不会包含).
> 3.  用双下划线__开头的实例变量或方法表示类内私有.
> 4. 将相关的类和顶级函数放在同一个模块里. 不像Java, 没必要限制一个类一个模块.
> 5. 对类名使用大写字母开头的单词(如CapWords, 即Pascal风格), 但是模块名应该用小写加下划线的方式(如lower_with_under.py). 尽管已经有很多现存的模块使用类似于CapWords.py这样的命名, 但现在已经不鼓励这样做, 因为如果模块名碰巧和类名一致, 这会让人困扰.

