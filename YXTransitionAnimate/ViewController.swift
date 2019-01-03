//
//  ViewController.swift
//  YXTransitionAnimate
//
//  Created by 王迪 on 2018/12/26.
//  Copyright © 2018 王迪. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XWInteractiveTransitionDelegate {
    
    func XWDelegateInteractiveTransition() -> XWInteractiveTransition {
        return interP!;
    }
    
    var interP : XWInteractiveTransition?;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray;
        
        let btn = UIButton(type: .custom);
        btn.setTitle("点击", for: .normal);
        btn.backgroundColor = UIColor.red;
        btn.frame = CGRect(x: 100, y: 100, width: 200, height: 50);
        self.view.addSubview(btn);
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside);
        
        
        interP = XWInteractiveTransition(gestureType:.left, animateType: .present);
        interP?.addPanGestureForViewController(vc: self);
        interP?.presentConifg = {
            self.btnClick(sender: UIButton());
        };
    }
    
    
    
    @objc func btnClick(sender: UIButton) {
        let p = OneViewController();
        p.delegate = self;
        self.present(p, animated: true, completion: nil);
    }

}

