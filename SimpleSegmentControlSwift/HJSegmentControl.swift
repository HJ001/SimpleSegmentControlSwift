//
//  HJSegmentControl.swift
//  SimpleSegmentControlSwift
//
//  Created by Hozonauto on 2018/10/23.
//  Copyright © 2018 Hozonauto. All rights reserved.
//

import UIKit

class HJSegmentControl: UIView,UIScrollViewDelegate {
    
    typealias IndexBlock = (Int) -> Void
    
    ///标题正常Color,默认黑色
    public var titleNormalColor = UIColor.black
    ///标题选中Color,默认红色
    public var titleSelectColor = UIColor.red
    ///默认选中的index=1，即第一个
    public var selectIndex = 1
    ///标题按钮ScrollView
    private var titleScrollView: UIScrollView!
    ///展示内容ScrollView
    private var contentScrollView: UIScrollView!
    ///选中的按钮
    private var selectTitleBtn: UIButton!
    ///按钮下横线
    private var line: UIImageView!
    ///存放所有的按钮
    private var btnArr = [UIButton]()
    ///当前点击的index
    private var indexBlock: IndexBlock!
    ///标题高度
    private let kTitleScrollHeight: CGFloat = 44.0
    
    //MARK: - required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 构造
    init(frame: CGRect, titles: Array<String>, contentViews: Array<Any>, clickIndexBlock: @escaping IndexBlock) {
        super.init(frame: frame)
        setupTitleScrollView()
        setupContentScrollView()
        configTitleBtn(titleArr: titles)
        configContentView(contentViewArr: contentViews)
        indexBlock = clickIndexBlock
    }
    
    private func setupTitleScrollView() {
        
        titleScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 10 + kTitleScrollHeight))
        titleScrollView.showsVerticalScrollIndicator = false
        titleScrollView.showsHorizontalScrollIndicator = false
        //titleScrollView.backgroundColor = UIColor.red
        addSubview(titleScrollView!)
        
        line = UIImageView()
        line.layer.masksToBounds = true
        line.layer.cornerRadius = 1.0
        line.backgroundColor = UIColor.red
        titleScrollView.addSubview(line)
    }
    private func setupContentScrollView() {
        
        contentScrollView = UIScrollView(frame: CGRect(x: 0, y: 10 + kTitleScrollHeight, width: frame.size.width, height: frame.size.height - kTitleScrollHeight-10))
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.isPagingEnabled = true
        contentScrollView.bounces = false
        contentScrollView.delegate = self
        contentScrollView.backgroundColor = UIColor.blue
        addSubview(contentScrollView)
    }
    
    private func configTitleBtn(titleArr: [String]) {
        var titleBtnX: CGFloat = 0
        for i in 0..<titleArr.count {
            let title: NSString = titleArr[i] as NSString
            let titleBtnWidth = title.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width
            let titleBtn = UIButton.init(type: .custom)
            titleBtn.frame = CGRect(x: titleBtnX, y: 0.0, width: titleBtnWidth + 40.0, height: kTitleScrollHeight)
            titleBtn.tag = i + 10
            titleBtnX += titleBtnWidth + 40.0
            titleBtn.setTitle(title as String, for: .normal)
            titleBtn.setTitleColor(titleNormalColor, for: .normal)
            titleBtn.setTitleColor(titleSelectColor, for: .selected)
            titleBtn.addTarget(self, action: #selector(titleBtnClick(btn:)), for: .touchUpInside)
            btnArr.append(titleBtn)
            
            if i == 0 {
                selectTitleBtn = titleBtn
                titleBtn.isSelected = true
                titleBtn.transform = CGAffineTransform.init(scaleX: 1.15, y: 1.15)
                lineFrame(with: titleBtn)
            }
            titleScrollView.addSubview(titleBtn)
        }
        titleScrollView.contentSize = CGSize(width: titleBtnX, height: kTitleScrollHeight)
    }
    
    private func configContentView(contentViewArr: [Any]) {
        let width = contentScrollView.frame.size.width
        let height = contentScrollView.frame.size.height
        contentScrollView.contentSize = CGSize(width: width * CGFloat(contentViewArr.count), height: height)
        for i in 0..<contentViewArr.count {
            let view: UIView = contentViewArr[i] as! UIView
            view.frame = CGRect(x: width * CGFloat(i), y: 0, width: width, height: height)
            contentScrollView.addSubview(view)
        }
    }
    
    private func lineFrame(with titleBtn: UIButton) {
        line.frame = CGRect(x: 0, y: 0, width: titleBtn.frame.size.height - 40, height: 3)
        var point = titleBtn.center
        point.y = titleBtn.center.y + titleBtn.frame.size.height/2 + 3
        line.center = point
    }
    
    private func scrollToSelectedBtn(index: Int) {
        
        for btn in btnArr {
            btn.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            btn.setTitleColor(titleNormalColor, for: .normal)
            btn.setTitleColor(titleSelectColor, for: .selected)
            if btn.tag == index + 10 {
                btn.isSelected = true
                btn.transform = CGAffineTransform.init(scaleX: 1.15, y: 1.15)
                UIView.animate(withDuration: 0.3) {
                    self.lineFrame(with: btn)
                }
            } else {
                btn.isSelected = false
            }
        }
    }
    //MARK: - 选取title
    @objc func titleBtnClick(btn: UIButton) {
        if btn != selectTitleBtn {
            btn.isSelected = true
            btn.transform = CGAffineTransform.init(scaleX: 1.15, y: 1.15)
            selectTitleBtn.isSelected = !selectTitleBtn.isSelected
            selectTitleBtn.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            selectTitleBtn = btn
        }
        UIView.animate(withDuration: 0.3) {
            self.lineFrame(with: btn)
        }
        contentScrollView.contentOffset = CGPoint(x: frame.size.width * CGFloat(btn.tag - 10), y: 0.0)
        indexBlock(btn.tag - 10)
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page: Int = Int(contentScrollView.contentOffset.x/contentScrollView.frame.size.width)
        indexBlock(page)
        self.scrollToSelectedBtn(index: page)
    }
    
}
