# 相关文献解读

@AikenHong 2021

在该笔记中记录一些后续需要阅读的文献清单，将其暂存在此，最终将其归类到需要的地方，为我们的论文提供更多的理论支撑和创新点设计依据。

## References

| Name/Topic              | Time | Public | Area |
| ----------------------- | ---- | ------ | ---- |
| FixMix,EnAET            |      |        |      |
| deep cluster            |      |        |      |
| Feature Center Using KL |      |        |      |

==supervised contrastive learning==

Modify our ce loss as supervised loss which may help seprate the features in the embedding space.

take some advices of this papers.

==MixMatch and FixMix==

Comfirm the way, how we organize the Few data with Incremental.

==SmoothLoss and Sharpen==

## Related Result

收集一些相关的实验结果作为我们的参照，这些参照结果可以帮助我们验证我们的Benchmark是否调整正确，以及我们的模型结果是否合理。

1. from supContrast
	
| LOSS            | Arch     | Setting      | Loss | Accuracy(%) |
| --------------- | -------- | ------------ | ---- | ----------- |
| SupCrossEntropy | ResNet50 | Supervised   | CE   | 75.3        |
| SupContrast     |          | Supervised   | Con  | 76.5        |
| SimCLR          |          | Unsupervised | Con  | 70.7        |

3. Incremental With Few and Imb
