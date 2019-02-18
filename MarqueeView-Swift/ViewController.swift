//
//  ViewController.swift
//  MarqueeView-Swift
//
//  Created by Tiny on 2019/2/18.
//  Copyright © 2019年 hxq. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
    }
}

