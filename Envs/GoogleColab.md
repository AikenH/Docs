# Google Colab 免费羊毛GPU 使用时候遇到的一些问题总结

@Aiken 2020 

在使用Google Colab的时候会有一些常见的使用错误，然后我们记录一些常见的错误的解决方案，方便后续使用。

**INDEX：**

- 命令行参数的输入问题

- tensorboard的执行方法

  ```bash
  # 在colab中写的时候要把前面的符号也写上
  %load_ext tensorboard  
  %tensorboard --logdir './runs'  
  ```

- command命令的使用：包括库安装和卸载之类的。
  主要就是在命令前+！

  ```bash
  !/opt/bin/nvidia-smi
  # 下面顺便解决了一下
  # ImportError: cannot import name 'PILLOW_VERSION'(版本问题)
  !pip uninstall pillow
  !pip install pillow==5.2.0
  ```

  

