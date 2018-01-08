//
//  ViewController.swift
//  图片轮播
//
//  Created by 刘通超 on 2018/1/5.
//  Copyright © 2018年 北京京师乐学教育科技有限公司. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imageArr = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        loadImageData()
        loadImageView()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func loadImageData() {
        for i in 1...5 {
            if let image = UIImage.init(named: "welcome_\(i)"){
                imageArr.append(image)
            }
        }
    }
    
    func loadImageView() {
        let scroll = CycleScrollView.init(frame: self.view.bounds)
        scroll.imageArr = imageArr
        self.view.addSubview(scroll)
        scroll.start(3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


