# MarqueeView-Swift


[Objective-C 版本](https://github.com/qqcc1388/MarqueeViewDemo)

![图片](https://github.com/qqcc1388/MarqueeView-Swift/blob/master/WX20190218-103403@2x.png)

### demo介绍

HXQMarqueeView 用来显示跑马灯的显示区域，接受滚动的数据源，并且手动控制动画的开启。
HXQBoardView 跑马灯中每组数据的显示区域，这个视图的长度是根据传入文字的多少，动态计算的，如果文字或者头像被点击了，可以通过block将点击的model传递到上一层
HXQMarqueeModel 跑马灯数据model 主要参数是文字内容和头像参数(头像是网络图片),设置完文字后，在setTitle这个方法中会动态的把文字的总宽度计算一遍，并赋值为titleWith,width的宽度为文字+头像的总宽度

### 使用方法

```
       //创建
        let marquee = HXQMarqueeView()
        marquee.backgroundColor = UIColor.cyan
        view.addSubview(marquee)
        //设置约束
        marquee.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(100)
            make.height.equalTo(30)
        }
        //初始化数据源
        var array = [MarqueeModel]()
        for i in 0..<5 {
            let item = MarqueeModel()
            item.title = "我完事了，你们呢\(i)"
            item.img = ""
            item.textColor = UIColor.black
            item.font = UIFont.systemFont(ofSize: 14)
            array.append(item)
        }
        //赋值
        marquee.items = array
        //监听点击
        marquee.queeSelection { (model, index) in
            print("\(model.title ?? "") + \(index)")
        }
```