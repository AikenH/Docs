# MLFlow 机器学习系统的使用

@Aiken 2020

*基于Python开发的DAG数据工作流系统，面向机器学习，支持Spark并行环境和K8S容器集群；*

MLFlow主要解决了三个问题，也就是三个我们可能会需要使用的功能：

1. **Tracking**：跟踪实验训练结果，记录算法参数，模型结果和运行效果等等；
2. Projects：对所有的算法项目有一套标准的projects概念，记录下代码版本，参数和运行环境这些东西，并且projects是可以拟合所有的算法框架的；
3. Models：解决的是打包和部署模型的这样一个行为，提供json接口给后续的flsk框架等等进行使用

## 基本部署

INSTALL：

DEPLOY：


## Tracking 实验版本跟踪

**Tracking**为本次描述的重点，来做一个训练过程中的版本管理，记录每一次训练的参数和变量信息等等，这样便于后续的恢复和实验信息的整理。便于统计和管理。使用的时候好像也是需要代码嵌入的部分，就是需要在代码中调用MLFlow的API。

但是在Tracking的时候有一个比较重要的点在于，这个方法和`Tensorboard`对原模型的参数的嵌入和Logging记录中<u>会不会产生冲突</u>，同时两个方法之间是不是有什么overlap；关键的问题：

- 这两个API能不能进行混合使用
- 怎么统一和区分两个方法的应用情景


## Reference

- https://mlflow.org/docs/latest/tracking.html
- https://mlflow.org/docs/latest/projects.html
- https://github.com/mlflow/mlflow
- https://blog.csdn.net/chenhuipin1173/article/details/100913909
- https://my.oschina.net/u/2306127/blog/1825638
- https://www.zhihu.com/question/280162556
