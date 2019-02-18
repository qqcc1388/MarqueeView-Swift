//
//  HXQMarqueeView.swift
//  hxquan-swift
//
//  Created by Tiny on 2018/11/20.
//  Copyright © 2018年 hxq. All rights reserved.
//  跑马灯

import UIKit

class MarqueeModel: Equatable{
    
    var title: String?  //内容
    
    var img: String?  //头像图片 url
    
    var textColor: UIColor = .black   //字体默认颜色
    
    var font: UIFont = .systemFont(ofSize: 14)  //字体大小

    var imageHolder: UIImage = HXQDefaultUserImage    //头像默认图片
    
    static func == (lhs: MarqueeModel, rhs: MarqueeModel) -> Bool {
        return  lhs.title == rhs.title &&
                lhs.img == rhs.img &&
                lhs.textColor == rhs.textColor &&
                lhs.font == rhs.font &&
                lhs.imageHolder == rhs.imageHolder
    }
}

class MarqueeItem: UIView {
    
    private var textLb: UILabel!  //文字label
    
    private var imgView: UIImageView!  //图片
    
    /// 重写setModel并赋值
    fileprivate var model: MarqueeModel?{
        didSet{
            if model != nil {
                textLb.text = model?.title
                textLb.textColor = model!.textColor
                textLb.font = model!.font
                //这里图片加载可以根据你项目中的情况来选择 我这里是sdWebImage
                imgView.sd_setImage(with: URL(string: model!.img ?? ""), placeholderImage: model!.imageHolder)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI(){
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(itemClick))
        addGestureRecognizer(gesture)
        textLb = UILabel()
        textLb.font = UIFont.systemFont(ofSize: 14)
        textLb.textColor = UIColor.black
        addSubview(textLb)
        
        imgView = UIImageView()
        imgView.layer.masksToBounds = true
        addSubview(imgView)
        
        imgView.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.width.equalTo(imgView.snp.height)
        }
        
        textLb.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(imgView.snp.right).offset(5)
            make.right.equalTo(-5)
        }
    }
    /// item被点击事件回调
    fileprivate var itemDidTap:(() -> Void)?
    
    @objc private func itemClick(){
        //将事件传递出去
        itemDidTap?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.layer.cornerRadius = imgView.bounds.size.width*0.5
    }
}


class HXQMarqueeView: UIView {
    
    /// 初始化scrollView
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.scrollsToTop = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    
    /// 初始化定时器
    private lazy var timer: Timer = {[unowned self] in
        let timer = Timer(timeInterval: 0.008, target: self, selector: #selector(startToMove), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI(){
        layer.masksToBounds = true
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    var marqueeHolder: String?
    
    var marqueeFontSize: CGFloat = 14
    
    var marqueeTextColor = UIColor.black
    
    public var items = [MarqueeModel](){
        didSet{
            
            //判断2次数据是否相同
            if oldValue == items {
                return
            }
            
            //关闭定时器
            if timer.isValid {
                timer.fireDate = Date.distantFuture
            }
            //移除scrollView中所有控件
            for v in scrollView.subviews{
                v.removeFromSuperview()
            }
            //显示默认
            if items.isEmpty{
                //如果需要显示默认值的话
                if marqueeHolder != nil{
                    let lb = UILabel()
                    lb.textAlignment = .center
                    lb.text = marqueeHolder
                    lb.font = UIFont.systemFont(ofSize: marqueeFontSize)
                    lb.textColor = marqueeTextColor
                    scrollView.addSubview(lb)
                    lb.snp.makeConstraints { (make) in
                        make.height.equalToSuperview()
                        make.left.equalTo(20)
                    }
                    //更新scrollView的ContentSize
                    scrollView.snp.makeConstraints { (make) in
                        make.right.equalTo(lb.snp.right)
                    }
                    layoutIfNeeded()
                    scrollView.x = 0;
                }
            }else{
                let margin: CGFloat = 10
                let gap: CGFloat = 20
                var last: MarqueeItem?
                for (i,model) in items.enumerated(){
                    let item = MarqueeItem()
                    item.model = model
                    item.itemDidTap = { [unowned self] in
                        self.selectionBlock?(model,i)
                    }
                    scrollView.addSubview(item)
                    item.snp.makeConstraints { (make) in
                        if last == nil{
                            make.left.equalTo(margin)
                        }else{
                            make.left.equalTo(last!.snp.right).offset(gap)
                        }
                        make.height.equalToSuperview()
                    }
                    last = item
                }
                //更新scrollView的ContentSize
                scrollView.snp.makeConstraints { (make) in
                    make.right.equalTo(last!.snp.right).offset(margin)
                }
                
                layoutIfNeeded()
                
                //拿到contentSize重新更新scrollView约束
                scrollView.snp.remakeConstraints { (make) in
                    make.width.equalTo(scrollView.contentSize.width)
                    make.top.bottom.equalToSuperview()
                    make.right.equalTo(last!.snp.right).offset(margin)
                    make.left.equalTo(self.snp.right)
                }
                //开始启动定时器
                timer.fireDate = Date(timeIntervalSinceNow: 0)
            }
        }
    }
    
    private var selectionBlock: ((MarqueeModel,Int) -> Void)?
    
    public func queeSelection(_ callBack: ((MarqueeModel,Int) -> Void)?){
        selectionBlock = callBack
    }
    
    @objc private func startToMove(){
        scrollView.x = scrollView.x - 0.5 ;
        if scrollView.x <= -scrollView.contentSize.width {
            scrollView.x = self.bounds.size.width;
        }
    }
    
    deinit {
        if timer.isValid {
            timer.invalidate()
        }
    }
}


