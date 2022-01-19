# 图像恢复技术在表情识别中的应用
说明：重点针对**超分辨率**技术  
日期：2020-03-06  

备注：
超分辨率在人脸识别上的多，但是表情识别上的确实不多，不过很多都会引用一波<br>
## 超分辨率在表情识别中的应用  
```
KEY WORDs ：

1. ("super resolution" OR "image restore") AND ("facial expression recognition" OR "emotion recognition")   
2. ("super resolution") AND  ("expression recognition")   
```

1.  [< Robust Emotion Recognition from Low Quality and Low Bit Rate Video: A Deep Learning Approach >](https://arxiv.org/pdf/1709.03126.pdf)
    > - 针对于低带宽传输的分辨率不足和比率低的应用场景  
    > - 基于facial expression recognition 的 emotion recognition
    > - 在解码器进行视频下采样的时候，**联合SR和识别**    

2. [< Effective image super resolution via hierarchical convolutional neural network >](https://www.sciencedirect.com/science/article/abs/pii/S0925231219312974)  
    > - 通过层次卷积神经网络(HCNN)来实现有校的SR
    > - 在facial expression recognition 中案例研究发现增强后的图像有助于提高识别性能

3. [< Spatio-temporal Pain Recognition in CNN-Based Super-Resolved Facial Images >](https://link.springer.com/chapter/10.1007/978-3-319-56687-0_13)  
    > - 有点擦边吧，就是基于超分辨率算法的多分辨率图像，对面部进行识别从而判断疼痛程度
    > - 也可能妹啥用，你可以考虑一下

4. [< Low-resolution facial expression recognition: A filter learning perspective >](https://www.sciencedirect.com/science/article/abs/pii/S0165168419304232)  
    > - 摘要中没有明确的提到Super-Resolution，
    > - 但是感觉低分辨率这个问题前缀，可能和SR有关系来着

5. [< PKU_ICST at TRECVID 2019: Instance Search Task >](https://www-nlpir.nist.gov/projects/tvpubs/tv19.papers/pku-icst.pdf)  
    > - 好像是什么比赛，过程中有一部分是面部表情检测
    > - 在识别之前采取了超分辨率的查询增强

6. [< Facial Expression Restoration Based on Improved Graph Convolutional Networks >](https://link.springer.com/chapter/10.1007/978-3-030-37734-2_43)  
    > - 针对分辨率低和部分遮挡的面部表情识别 
    > - GAN IGCN RRMB 修复和超分辨率面部表情    




## 图像恢复技术、图像增强技术、人脸增强技术在表情识别中的应用  
```
KEY WORDs：

1. ("super resolution" OR "image restore") AND ("facial expression recognition" OR "emotion recognition")  
2. ("image restore")  AND  ("expression recognition")  ——NONE
3. ("Image enhancement") AND ("facial expression recognition")
4. ("face enhancement") AND ("facial expression recognition")
5. ("Image restoration") AND ("facial expression recognition")
```
1. [< Efficient facial expression recognition via convolution neural network and infrared imaging technology >](https://www.sciencedirect.com/science/article/abs/pii/S1350449519306620)  
    > - 离散小波变换正则化和快速盲恢复模型来重建红外光谱。。。。来帮助面部表情识别

## 针对光，姿势变化，噪声和遮挡的人脸识别？AND 其他
1. [< Facial appearance and texture feature-based robust facial expression recognition framework for sentiment knowledge discovery >](https://link.springer.com/article/10.1007/s10586-017-0935-z)  
    > - 没有提到超分辨率或是图像重建
    > - 但是有提到标题那几个，结合局部和全局特征...
    
1. [< Improving Facial Emotion Recognition Systems with Crucial Feature Extractors >](https://link.springer.com/chapter/10.1007/978-3-030-30642-7_24)  
    > - 是对表情识别的增强但是好像不是图像增强.....
    > - 基于特征提取的增强把