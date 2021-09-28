# windows 操作技巧

## Abstract

written by Aiken, 2020  
this document is about windows  tips

---

**Contents:**

- [CMD输出结果筛选](#Filter the Filter the Result of Common carrying out)
- [生成新GUID](#GUID)
- [倍速播放百度网盘](#PANBAIDU)
- [office 自动保存的恢复](#Office AutoSave)

shift+右键，在此处打开powershell；

## Filter the Filter the Result of Common carrying out

```powershell
Common-u-want-to-carry-out | findStr "String" 
# for example
conda list | Select-String ("matplot" , "pillow", "scipy", "tensorboard")
```

## GUID

```powershell
new-guid
```

## PANBAIDU

百度网盘的网页版倍速播放的技巧：

```html
videojs.getPlayers("video-player").html5player.tech_.setPlaybackRate(2)
```

## Office AutoSave

- 首先通过设置（选项）界面找到自动保存的asd文件的地址
- 在信息-管理文档中选择ASD进行对文档的恢复
