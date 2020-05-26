# LIRefresh
swift 刷新 加载框架
## swift 刷新加载库LIRefresh功能介绍
### LIRefresh主要针对页面的刷新加载功能，使用简洁明了
 由于项目用swift重构，swift当前刷新加载框架没有特别适合我的，所以我自己搭建了这么一个[LIRefresh](https://www.jianshu.com/p/914ebc548247)框架，纯swift封装，喜欢给个star。

### 具体使用说明如下：
1. 调用刷新事件，如下所示：
```  
  
self.tablview.li.header = NormalRefreshHeader.headerWithRefreshing(block: {[weak self] in
     self?.loadMoreData()
})

self.tablview.li.footer = NormalRefreshFooter.footerWithRefreshing(block: {[weak self] in
     self?.loadMoreData()
}) 
  
```
![图1](https://upload-images.jianshu.io/upload_images/6573541-b7430a4b12cf716b.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200)  
刷新调用header，加载调用footer  

2.  数据请求完毕不要忘记调用endRefreshing方法：
```  
  
self?.tablview.li.header?.endRefreshing()

self?.tablview.li.footer?.endRefreshing()  
  
```
![图2](https://upload-images.jianshu.io/upload_images/6573541-42d7fdac7bbf6120.png?imageMogr2/auto-orient/strip|imageView2/2/w/746)  
结束刷新状态才能进行下次刷新  

3. 本库本着轻量化，没有过多的定制化设计，如果想要自定义刷新控件可以继承RefreshHeader或者RefreshFooter  
* Router主要负责根据URL路径进行跳转的功能：
* 1. 重写state属性，根据不同状态写出动画或其他，具体状态的变化逻辑，RefreshHeader和RefreshFooter已经写好，不需要去管理，只要关注自己要改进的代码即可    
![图3](https://upload-images.jianshu.io/upload_images/6573541-67e2a3bb334a46be.png?imageMogr2/auto-orient/strip|imageView2/2/w/1162)  
* 2. 重写init初始化方法，在这里修改刷新或加载控件的高度即可，也可修改加载的灵敏度，0.5代表当加载footer出来一半的时候就开始调用加载方法，如下图所示：  
![图4](https://upload-images.jianshu.io/upload_images/6573541-f58476f2ca82409a.png?imageMogr2/auto-orient/strip|imageView2/2/w/834)  
* 3. 重写pullingPercent属性，这里面可以根据下拉或者上拉的百分比绘制想要实现的动画      
![图5](https://upload-images.jianshu.io/upload_images/6573541-c332c98d8ad92b5f.png?imageMogr2/auto-orient/strip|imageView2/2/w/1108)  
  
# 我觉得这样自定义起来比较宽松没有局限性，可以根据大家公司的需求进行自定义刷新加载控件的样式，灵活多变，相对于提供很多的api来控制样式来说，本库这种方式也方便大家对刷新加载控件的理解，没准嫌弃我的库去自己写了也不一定，可以说本库可以节省大家工作量也可以给大家提供参考。


