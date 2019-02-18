//
//  Const.swift
//  t1
//
//  Created by Tiny on 2018/10/23.
//  Copyright © 2018年 hxq. All rights reserved.
//  存放常量枚举宏定义

import UIKit

//MARK:- 屏幕宽高
let SCREEN_WIDTH = UIScreen.main.bounds.size.width

let SCREENT_HEIGHT = UIScreen.main.bounds.size.height

//MARK:- 是否是IPX系列
let IS_IPhoneX_Series = (UIApplication.shared.statusBarFrame.height == 44)

//MARK:- 比例系数
let HXQWIDTHRATIO = (SCREEN_WIDTH/375.0)

//MARK:- 根据比例系数按比例计算宽高
func SCALE_WIDTH(_ width: CGFloat) -> CGFloat{
    return width*HXQWIDTHRATIO
}

func SCALE_HEIGHT(_ height: CGFloat) -> CGFloat{
    return height*HXQWIDTHRATIO
}

//MARK:- 根据比例系数缩放字体大小
func HXQFont(_ a: CGFloat) -> UIFont{
    return UIFont.systemFont(ofSize: a)
}

func HFont(_ a: CGFloat) -> UIFont{
    return HXQFont(a*HXQWIDTHRATIO)
}

func HBFont(_ a: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: a*HXQWIDTHRATIO)
}

func RGB(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat,_ a: CGFloat = 1.0) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func COLOR_RANDOM() -> UIColor{
    return RGB(CGFloat(arc4random_uniform(256)), CGFloat(arc4random_uniform(256)), CGFloat(arc4random_uniform(256)))
}

//MARK:- 图片url快速创建
func APP_IMG(_ imgUrl:String?) ->String{
    if imgUrl == nil {
        return ""
    }
    return imgUrl! .hasPrefix("http") ? imgUrl! : "https:\(imgUrl!)"
}

func APP_URL(_ imgUrl:String?) ->URL?{
    if imgUrl == nil {
        return nil
    }
    return URL(string: imgUrl! .hasPrefix("http") ? imgUrl! : "https:\(imgUrl!)")
}

//MARK:- 图片
let HXQDefaultUserImage = UIImage(named: "UserBitmap")!

