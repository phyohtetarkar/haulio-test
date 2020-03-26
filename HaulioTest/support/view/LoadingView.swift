//
//  UILoadingView.swift
//  vstore-myanmar-ios
//
//  Created by Phyo Htet Arkar on 3/19/20.
//  Copyright © 2020 Phyo Htet Arkar. All rights reserved.
//

import UIKit
import Lottie

class LoadingView: UIView {
    
    static let instance = LoadingView()

    @IBOutlet var parentView: UIView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var animationView: AnimationView?
    
    var loading = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoading() {
        animationView?.play()
        loading = true
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        parentView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        animationView?.center = parentView.center
        
        UIApplication.shared.keyWindow?.addSubview(parentView)
        
        
    }
    
    func dismiss() {
        animationView?.stop()
        loading = false
        parentView.removeFromSuperview()
    }
    
    func refresh() {
        if loading {
            animationView?.center = parentView.center
            parentView.setNeedsLayout()
        }
    }
    
    private func setup() {
        animationView = AnimationView(name: "loading")
        animationView?.loopMode = .loop
        animationView?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        parentView.addSubview(animationView!)
        
        
    }
    
}
