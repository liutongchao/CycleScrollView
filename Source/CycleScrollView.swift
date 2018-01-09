//
//  CycleScrollView.swift
//  图片轮播
//
//  Created by 刘通超 on 2018/1/5.
//  Copyright © 2018年 北京京师乐学教育科技有限公司. All rights reserved.
//

import UIKit

//滑动方向
enum ScrollDirection{
    case left
    case right
    case center
}

protocol CycleScrollViewDelegate {
    func cycleScrollView(view:CycleScrollView, tap index:Int)
}

class CycleScrollView: UIScrollView {
    private var _imageViewArr = [UIImageView]()
    private var _imageArr = [UIImage]()
    private var _currentIndex:Int = 0
    private var _timer: Timer?
    
    var cycleDelegate: CycleScrollViewDelegate?
    var cycleTapBlock: ((Int)->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configSelf()
        loadImageView(frame: frame)
        addTapGestuger()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configSelf() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.isPagingEnabled = true
        self.delegate = self
    }
    
    fileprivate func loadImageView(frame:CGRect) {
        for i in 0...2 {
            let imageView = UIImageView.init(frame: CGRect.init(x: CGFloat(i) * frame.width, y: 0, width: frame.width, height: frame.height))
            self.addSubview(imageView)
            _imageViewArr.append(imageView)
        }
        self.contentSize = CGSize.init(width: 3*frame.width, height: frame.height)
        self.contentOffset = CGPoint.init(x: frame.width, y: 0)
    }
    
    fileprivate func addTapGestuger(){
        guard _imageViewArr.count == 3 else {
            return
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapTheImageView))
        
        let imageView = _imageViewArr[1]
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
    }
    
    @objc func tapTheImageView() {
        self.cycleDelegate?.cycleScrollView(view: self, tap: _currentIndex)
        if self.cycleTapBlock != nil {
            self.cycleTapBlock!(_currentIndex)
        }
    }
    
    deinit {
        _timer?.invalidate()
        _timer = nil
    }
    
}
extension CycleScrollView{
    var imageArr:[UIImage] {
        get{return _imageArr}
        set{
            _imageArr = newValue
            resetCurrentIndex()
            refreshImageSource()
        }
    }
}
//mMARK: Timer
extension CycleScrollView{
    func start(_ timeInterval:TimeInterval? = nil) {
        let interval = timeInterval == nil ? 2 : timeInterval!
        _timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerRefresh), userInfo: nil, repeats: true)
    }
    @objc func timerRefresh() {
        self.setContentOffset(CGPoint.init(x: 2 * self.bounds.width, y: 0), animated: true)
    }
}

extension CycleScrollView{
    
    fileprivate func resetCurrentIndex() {
        _currentIndex = 0
    }
    
    fileprivate func resetScrollOffset() {
        self.contentOffset = CGPoint.init(x: self.bounds.width, y: 0)
    }
    
    fileprivate func refreshImageSource() {
        guard _imageArr.count > 0 else {
            return
        }
        if _currentIndex  == 0 {
            _imageViewArr[0].image = _imageArr.last
        }else{
            _imageViewArr[0].image = _imageArr[_currentIndex-1]
        }
        _imageViewArr[1].image = _imageArr[_currentIndex]
        
        if _currentIndex  == _imageArr.count - 1 {
            _imageViewArr[2].image = _imageArr.first
        }else{
            _imageViewArr[2].image = _imageArr[_currentIndex+1]
        }
    }
    
    fileprivate func refreshCurrentIndex(direction:ScrollDirection) {
        guard _imageArr.count > 0 else {
            return
        }
        switch direction {
        case .left:
            if _currentIndex == 0{
                _currentIndex = _imageArr.count - 1
            }else{
                _currentIndex -= 1
            }
        
        case .right:
            if _currentIndex == _imageArr.count - 1{
                _currentIndex = 0
            }else{
                _currentIndex += 1
            }
            
        default:
            return
        }
    }
    
    fileprivate func scrollTo(direction:ScrollDirection) {
        refreshCurrentIndex(direction: direction)
        refreshImageSource()
        resetScrollOffset()
    }

}

extension CycleScrollView:UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _timer?.fireDate = Date.distantFuture
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        _timer?.fireDate = Date.distantPast
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            scrollTo(direction: .left)
        }
        if scrollView.contentOffset.x == scrollView.bounds.width {
            print("不动")
        }
        
        if scrollView.contentOffset.x == 2 * scrollView.bounds.width {
            scrollTo(direction: .right)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollTo(direction: .right)
    }
}
