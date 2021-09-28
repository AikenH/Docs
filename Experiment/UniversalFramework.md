# Universal Framework Readme

@aiken 2021  Framework for CV

## Abstract

Try To make structure universal，编写一个自己的通用的架构，框架化，满足通过不同的model文件和特殊配置文件就能实现不同的模型的一个架构。

只是一个初步的框架集成，还有很多没有完善的地方，目前测试了ResNet18 跑Cifar10，没有什么问题，如果有什么可以改进的地方，或者你实现了一些Feature，***\*欢迎进行交流\****！（私下联系我最好啦！） 

感谢帮助

\> P.S 一些备注

\> 1. 还有一些可以参数化或者可视化的地方，由于时间关系目前还没有修改，有兴趣的可以自己先添加一下 

\> 2. 暂时只集成了分类的模块，后续可能会随缘扩展

## Quick Start

本框架主要希望实现的是：易读性，可拓展性，以及简洁；

希望将重要的，可变的参数都尽量的分离出来，通过配置文件和命令行参数去定义和运行我们的网络，在这种情况下实现一个较好的

## Framework Design

**PURPOSE：新类发现和模型自主更新**；同时希望能够解决**长尾分布**的数据情景；

**ANALYSIS：**为了实现这种模型的自主更新过程，将整体的流程分成两个部分

- 启动（start）：

  self supervissed 等方法无监督的学习特征提取网络（这种方式是否会对Unbalance产生增益）

- **初始化预测模型：**
  基于**Unbalance**的数据训练一个基础的分类模型，在输出分类结果的同时需要输出对应的预测**置信度**，这两个其实都是一些简单的Trick，而最重要的是Backbone的分类效果需要得到保证，同时**Backbone需要支撑后续的模型蒸馏**更新。

![image-20210921164615348](https://gitee.com/Aiken97/markdown-image/raw/master/img/20210921164616.png)

- **模型的自主更新和迭代：**
  Online：在线运行推断模型，通过**置信度输出筛选**出新类样本，将样本在**样本池**中收集
  Offline：基于样本池的规模和评估触发离线更新：**伪标签生成模型**；**模型蒸馏和更新**

创新点：自主新类发现和学习

![image-20210921165259383](https://gitee.com/Aiken97/markdown-image/raw/master/img/20210921165300.png)



**Unbalance：**

| Strategy            | Status | Desc                       |
| ------------------- | ------ | -------------------------- |
| **Two Stage**       | Todo   | 可以作为一个Baseline策略   |
| **Causla Analysis** | Doing  | 基于TwoStage做出的偏差校正 |
| **Rebalance**       | TBD    | 作为数据增强的辅助策略     |

**置信度生成方法：**

置信度生成的方法可以从**Active Learning**等领域的文章中作为参考

| Strategy                | Status    | pros and cons                                                |
| ----------------------- | --------- | ------------------------------------------------------------ |
| **Evidential Learning** | Doing     | pros：有坚实的数学基础；<br />cons：增加模型复杂度和训练的难度 |
| **Least Confident**     | Done      | pros：实现简单，不影响原有复杂度<br />cons：原理上简单，不是特别靠谱 |
| **Entropy and...**      | TBD<br /> | 同上，可以随时取代测试                                       |

**置信度准确率输出：**

使用下面的指标去做置信度输出的准确率评估
$$
ac = NumNew/NumLowconfi 
$$
$$
recall = NumOld/NumLowconfi
$$

**伪标签生成模型：**

在进行新的模型训练，之前，要将数据集混合现有的已知数据，生成的方式主要可以分成两种，**网络**或者**聚类**

- 聚类：通过现有类别的聚类结果，还能判断聚类的质量
- 网络：切分Mini-Batch进行Meta-Like的Training，训练FSL或者Unsupervised的模型，输出伪标签预测（一致性原则）

创新点：

- 在做伪标签生成之前，我们基于原本特征特征提取器，组合数据特征作为后续的数据基础
- 通过混合的数据集中的伪标签生成，和标签的双指标，定义损失，去更新原有的特征提取架构同时赋予新类伪标签。这是由于我们知道部分数据集的真实标签，我们就可以通过这一部分的信息去做一个对应的标准。
- 这样就可以通过生成的伪标签对原特征提取器进行一定的更新，这种更新应该是交替进行的，因为我们不知道哪个Coder是更为可靠的一个label generator。（除非我们使用的是有终点的聚类）

**模型更新：**

参考蒸馏学习的思想，使用原有网络和pseudo generator作为Teacher 进行模型的更新，Duplicate Feature Extractor，Modify FC（num_class），考虑使用双重循环去freeze，利用不同的lr training网络的两部分。

- 在这里参考其他蒸馏学习的方法，去设计这种Teacher给予Label或者Parms的机制

- 考虑基于prototype的方法，是否会和聚类的方法更加的匹配，但是prototype

  的方法和我们之前设想的实验过程应该是一个区分度比较大的情况

创新点：

- double teacher to generate a new siamese model which train in two diff phase for feature extractor and classifier


## DevLog

开发中的一些疑问和细节会放在这个地方，包括开发的RoadMap，实现中遇到的问题，FrameWork设计中的主要矛盾和问题；

### RoadMap

开发路线图部分，主要分为基本的模块，和不同的训练方式两个阶段，用来集成完整的Framework.

#### Data

数据集收集和初始数据的采样处理：

| Function                    | Stage | Desc                                           |
| --------------------------- | ----- | ---------------------------------------------- |
| New Class（Larget version） | todo  | like mini-imagenet，`mv` some cls to other dir |
| Unbalance                   | todo  | sampling data in differ rate                   |
| Few Shot                    | done  | testing the model only have few data           |

#### Model


| Functional Part       | Stage  | KeyWord/Method                                          |
| --------------------- | ------ | ------------------------------------------------------- |
| **Basic Training**    | abjust | ImageNet                                                |
| **Backbone**          | done   | Swin（abjust params and train on ImageNet）<br />       |
| **LT and Confidence** | todo   | two-stage<br />rebalance<br />causal analysis           |
| **FSL**               | doing  | Self-Supervise<br />Cluster                             |
| **Cluster**           | todo   | New-Descover<br />K-Means<br />Self-Supervised + linear |

#### Framework

| Training Process         | Stage | KeyWord/Method       |
| ------------------------ | ----- | -------------------- |
| **Meta Training**        | todo  |                      |
| **Multi-Stage Training** | todo  |                      |
| **Distill Training**     | todo  | Incremental learning |
| **Unsupervised**         | todo  |                      |
| **Clustering**           | todo  |                      |

### Swin-T

问题描述：在cifar10，或者ImageNet数据集上训练的时候，损失曲线过早收敛，识别准确率很低；

问题分析：

- [x] LR过高，没有办法学到好的解

  框架中学习率设置的问题，同理可以分析其他的和config中的冲突

- [ ] 数据集标签的问题

- [ ] 模型定义的问题

## Reference

**Confidental**

[ 主动学习(Active learning)算法的原理](https://www.zhihu.com/question/265479171/answer/1474978784)

**ResNet** 

[Pytorch.org](https://pytorch.org/vision/stable/_modules/torchvision/models/resnet.html#resnet18)、[官方实现解读](https://www.cnblogs.com/wzyuan/p/9880342.html) 、[ResNet详解与分析](https://www.cnblogs.com/shine-lee/p/12363488.html)、[Pytorch手工实现](https://zhuanlan.zhihu.com/p/149387262)

**Mini ImageNet**

[用Mini-ImageNet训练分类网络](https://blog.csdn.net/qq_37541097/article/details/113027489)

**Swin Transformer**



## Project Management

**Universal_Framwork Project Tree** 项目文件夹管理，文件架构

**├─ config** 配置文件和命令行读取

│ ├─ argparser.py 读取命令行参数

│ ├─ cifar10_effnet.yaml 配置文件

│ └─ template.yaml 文件模板

**├─ data** 数据获取和数据增强

│ ├─ GetData.py 

│ ├─ dataAugment.py

│ ├─ dataUtils.py

│ └─ unzipImageNet.sh

**├─ layers** 网络层定义和设计

│ ├─ Classifier_L.py

│ ├─ clusters.py

│ ├─ convolution.py

│ ├─ ezConfidence.py

│ └─ new_activation.py

**├─ loss** 损失函数

│ ├─ common_loss.py 基本的损失函数

│ └─ evidential_loss.py 置信度损失函数

**├─ util** 运行脚本可视化脚本

│ ├─ Visualize.py 

│ ├─ metric.py 

│ ├─ runningScript.py 训练和整体框架

│ └─ utils.py

**├─ model** 骨架模型

│ ├─ EfficientNet.py

│ ├─ ResNet.py

│ └─ ViTs.py

**├─ save_model模型保存** 

**├─ log 输出记录**

**├─ run.sh** 命令行运行指令

**├─ main.py 程序入口**

├─ .gitignore

└─ README.md
