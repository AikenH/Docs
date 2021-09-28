# NIPS 中国预讲会

## Long-Tailed Classicification by Keeping the Good and Removing the Bad Momentum Causal Effect



1. re-sampling 、re-weighted（这些方法都需要提前预知分布，就和人类的本能比较接近了）， 问题一般是对于头部的过拟合，对尾巴的欠拟合

2. two-stage re-balancing
3. 基于优化器的动量调整
4. 长尾数据分布本身带来的优化偏折项。
5. 可以被广泛的应用于各种不同的数据集

## 3D视觉部分的启发

光度法3维重建





## self-supervised and transfer

**MOCO**: 无监督的的预训练+fine-tune在很多地方超过有监督了。

（主要是潜力方面）

ImageNet-1k linear evaluation：用特征直接接简单的线性来进行分类，来评估本身的特征提取效果。

SimCLR 简化版的MOCO，还有一些其他的发现，data-augmentation

这些trick用在MOCO上甚至效果更高了比SimCLR

NIPS：

BYOL：moco需要很大的负样本，这个方法不需要负样本，但是设计了一个不对称的设计，

SwaV：Deep clustering + contrastive learning

InfoMin：Pascal 上做 和对Augmentation的仔细研究

PIC：将2stage->1stage（不用做对比了）



After NIPs：

![image-20201127155704260](https://gitee.com/Aiken97/markdown-image/raw/master/img/20210911211646.png)

- higher accuracy

- better understand

- 为什么不需要负样本，而不会坍缩

hekaiming ：孪生网络的工作。