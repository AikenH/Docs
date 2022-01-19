# Using Judgment Instead of Annotation

为了解决数据集的标注过程中工作量过大，在实际情境下难以完成需要的数据集构建，或者成本过高的问题，参考了AL，FSL的一些思路，主要的思路分析如下。

在证实可行性之前，先简要分析一下主要的思路即可。

## Overall

- 基于reinforcement learning(人类参与)和self-learning(机器自学习)为主体框架，以各种FSL算法作为backbone，然后再不断的迭代中，提升辨别和分类能力。

- 人类参与的形式：把Annotation的过程，转化成Judge的形式：分类的化好说，定位的话，judge可以不只是一个True or False。

  > 尽量做成一个项数有限的多选的离散情况。Full correct-smaller-biger-need to pan -completely loss 之类的，同时也可以将2-3歌epoch作为一次iteration的周期，然后对迭代次数本身进行考察

- 把这样的Judge作为RL中的reward，或者说是作为一种对prior knowledge的补充，帮助算法学习到最佳的H。

  > 1. 对Judge的利用上也可以参考weakly-supervised的方法，当成一个弱标签
  > 2. 给出Judge的同时，在扩充数据集，完成后续的**增量自学习**的同时，是否能做一个BP，对现有网络进行一个初步的修正方向指示。

- 算法的核心仍然在于FSL的算法部分：

  > 1. 但是算法的meta-learner的**边际增益**在下降的话，有没有办法使得这个增益曲线，后移，让我们在可以容忍的地方，已经获取了足够的数据标注
  >    for example：
  >    一开始的few-shot 得到了50%的正确率，我们通过Judge能快速的建立50%的数据集，然后再兵分两路feed 正确和错误的数据进入网络，进行类似**Label propagation**的方法，然后就能从方法增益上获取更多的标注收益，然后在效益进一步下降之前，已经构建了一个足够大的数据集？
  >    solve problem：边际增益递减
  > 2. 根据不同FSL算法的P特性，结合Full supervised的ML算法的特性，在不同的data situation下，采用不同的整合算法，从而取得我们需要的辅助数据标记效果？针对不同阶段适应不同网络。
  > 3.

## Think it again

### 假如使用模板匹配

**基本思路**

- 训练一个分类上较好的embedding，然后通过聚类算法，（同时要参考slide windows）算法，减少需要匹配的模板（snips），然后基于Network（Embeding）的输出去匹配：**（平移 伸缩，切分组合的相似性应该保持）**，匹配完输出类别结果，让人为的去判断。
- Few-shot的情况，扩充完以后针对性的对各类的模板进行更新（META？）（增量学习？）好像有点Learning with External Memory的味道
- 将人为判断的模型，**以强化学习的方式：reward**，进行网络的输入，对网络进行改造：对embedding进行改造，得到一个具有更好性质（**泛化能力，准确率**）的embedding。

**仍需思考**

- 在视频分割层面怎么去做匹配之类的操作什么的

## Localization

- localization的部分离不开聚类的理论，比如oic loss，就是从判别度之类的来切分出最具识别度（类内和类间的间距较大的embedding function）的片段？
- “类内间距小，类间间最大”，对snip进行初次的切片，然后在对这些进行分类
- 聚类或模板匹配，在定位这样的层面，模板匹配是不是会表现得更好。

## Classification

## Analyze the effectiveness of algorithms

1. 通过判断的方法，是否能以低于纯标注的工作量，有效的在指定的轮次（RL+Self Learning一次为一轮），也就是有限的人工干预次数后，达到令人满意的效果。
   **总结：**bias<5%: epoch * per-workload < total-workload
2. 是否能够通过这样Judge(RL)+FSL的方法，After Limited Epochs，能够快速构建数据集。
3. 实际上如果只是**针对Classification**本身，那么这样的方法应该改成：FSL +Self-learning的效益提升改进。用**Meta-Learning的思路**来看的话：关键就在于效益曲线，如果进一步提升效益需要的数据量随之增长的速度超过一定的Threshold，那么就没有必要做下去了。
4. 如果是Video维度的**时间定位**~~图像维度的**图像分割**，那么在这个时候，把Label行为本身，转换成一个Judge的操作，才在Workload减少本身，有一定的意义。

## Some Problem

- 倘若我们使用FSL的时候，N-way K-shot中N若大了，问题的复杂程度会上升，那么是不是算法的效果，会不够好，此时是不是应该从N比较小的时候，通过N-K扩充数据量，然后再逐渐的上升N，最后转化为full supervised
- 当我们的Judge为error的时候，如何对negative的pseudo-label在网络中进行利用
- 如何更好的结合localization和classification，可能要参考一下two-stream之类的，但是他们都是在用weight比较生硬的对Loss进行结合，那么有没有更有机的结合方式？

## Experiment Detail v1：GCN FSL version

### 算法的一些修改细节

```python

def ✅modify_eval(*parameterlist):
    '''在验证过程中增长正确识别的dict，或者同时构建识别错误的dict'''
    '''在不同的epoch训练的时候需要重新读取数据，但是对同一批数据集，我们不能进行简单的单次训练
    要么通过实验效果的边际效益/算法稳定来进行选择，要么通过指定hyperparameter确定固定训练伦次'''
    # 应该是一开始进行普通的FSL，等算法效果稳定以后再执行人工干预操作 or 边际效益降低到一定程度的时候来做这个操作
    pass

# 通过对类的实例中的dict进行修改在进行调用
# 定义方法修改dict


def ✅early_stop(*parameterlist):
    # 通过early stop来对dict进行reload和改进，可以在argument设置一个参数来控制early_stop的执行模式
    # 添加一个状态值，然后通过状态值在eval中执行操作，例如如下的两种方式
    MaxNum = len(singleclass)
    Judgement = len(dict1[class1])/MaxNum
    pass

def ✅modify_dataloader(*parameterlist):
    '''尽量使用自己的数据模型，这样在后续进行开发的时候能够更方便的拓展到其他的算法
    1. dataloader需要进行重构：因为需要阶段性的生成datalist
    2. 可能需要直接对datalist进行操作，可能需要直接对该值进行操作，后面看看怎么做'''
    pass


# ✅ 或者此中关键在于load_tr_batch()，但是问题在于，这个函数对数据的读取是随机进行的，有没有办法让函数读取到的是固定的list？
'''我觉得应该是可以的，现在是随机选择图片，所以我只需要让每个类别中的初始图片是固定的index就可以执行这样的操作，在获取数据的时候进行shuffle，然后再后续选择训练的时候不在随机选择即可，然后给每个class一个list包含他们所拥有的shot，然后基于这样的shot来设置训练中获取的shot参数'''
# ❌是不是应该换个New项目来做
'''暂时先对之前的想法进行一个实现试试'''
A = self_dataloader(*args)

```

### :zap: Something we should pay attention to

- [x] 在改变训练模式后怎么做checkpoint？
  有没有办法保存已有的list的情况：可能没有必要，我们只需要保证模型继承，然后根据迭代的情况快速的对数据集进行更替就可以了。
- [x] 训练指标：(不能使用本数据集的pretrain，会破坏实验的验证性)
  所以需要删除原本使用预训练的模型，禁用预训练module，以及freeze_cnn
- [x] 首先我们需要使用修改过后的数据集来进行一次测试，看算法的效果是否能够保持在一个较高的水平，如果算法的效果切实可行的话，在执行加入了数据填充部分的代码测试
- [x] positive class是指定每个batch中的正类把，然后将其他的样本作为该episode中的Negative，也就是负例，通过这样的设定去模拟一个完整的类别样本。这样需要重构之前编写的部分

### ®DEBUG和TEST 安排

记录train和test两个阶段的实验结果

- [x] 首先记录原训练结果:colab 上的元模型
  1. 记得删除预训练和freeze_cnn模块
  2. 记录几种情况下的效果
  
- [x] 接着 修改成data_v2的数据读取，检测数据算法是否编写正确
  1. 算法的准确率与原本是否有区别
  2. 改写数据模块的正确性与否
  
**这一部分👆的第一次实验，在data_v2的编写上存在一定的问题，进行修改并重新实验查看结果。**

- [x] 最后将整体算法嵌入进去，看看效果
  1. 先debug，将算法调试到可以正常运行的情况下
  2. 然后根据表现调整具体算法的逻辑错误
  3. 比较算法表现

### 实验结果

| phase\indicator(no pretrain)(no freeze cnn)                  | Nway | Nshot | iter  | ACC Tr  | ACCTe        |
| ------------------------------------------------------------ | ---- | ----- | ----- | ------- | ------------ |
| origin GNN Few-shot learning(k80)                            | 5    | 5     | 50000 | 58.69%  | 57%          |
|                                                              |      |       |       |         |              |
| GNN Few-shot learning v2（modify the data loading）❌         | 5    | 5     | 18000 | 48.52%  | 22.96-23.52% |
| V2 改（没有意义，从loss和acc的表现来看，算法由于训练数据过少，后续的训练过拟合了，算法的效果根据数据的浮动很大） | 5    | 5     | 16000 | 20%-62% | ❌            |
| V3：eval中的positive-shot随机                                | 5    | 5     |       |         |              |
|                                                              | 5    | 5     |       |         |              |
| Mydemo                                                       | 5    | 5     |       |         |              |
| 应该补充个指标，就是最终的数据情况                           |      |       |       |         |              |


| phase\indicator(no pretrain)(no freeze cnn)         | Tr T/F    | Te T/F   | loss Tr | loss Te                       |
| --------------------------------------------------- | --------- | -------- | ------- | ----------------------------- |
| origin GNN Few-shot learning                        | 2871/4992 | 285/500  | 1.132   | :negative_squared_cross_mark: |
|                                                     |           |          |         |                               |
| GNN Few-shot learning v2（modify the data loading） |           | 574/2500 | 2.692   | :negative_squared_cross_mark: |
|                                                     | ❌         | ❌        | ❌       | ❌                             |
| Mydemo                                              | 1064/4662 |          | 1.714   |                               |
|                                                     |           |          |         |                               |

![image-20200716215216569](https://gitee.com/Aiken97/markdown-image/raw/master/img/20210911212606.png)

### Summary

1. 不该使用第三方重构的代码，去理解，破坏了原作者的逻辑
2. 对fewshotlearning的理解和positive class的理解需要进一步分析
3. 对meta-learning 的问题设置有初步的了解
4. 如何去编写数据
5. positive class，就是只识别positive class 其他的都当成负类，所以每个episode都只输出一个预测结果

