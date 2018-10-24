//
//  ViewController.swift
//  SimpleSegmentControlSwift
//
//  Created by Hozonauto on 2018/10/23.
//  Copyright © 2018 Hozonauto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let colorArr = [UIColor.red,UIColor.blue,UIColor.orange,UIColor.cyan,UIColor.yellow]
        var viewArr = [Any]()
        for item in colorArr {
            let view = UIView()
            view.backgroundColor = item
            viewArr.append(view)
        }
        
        let frame = CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: self.view.bounds.size.height-64)
        
        let segmentControl = HJSegmentControl.init(frame: frame, titles: ["精选","世界杯","大西瓜","分享","喜爱"], contentViews: viewArr) { (index) in
            print("当前第\(index)个View")
        }
//        segmentControl.titleSelectColor = UIColor.purple
        self.view.addSubview(segmentControl)
        
    }


}

