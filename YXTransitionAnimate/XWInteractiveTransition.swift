//
//  XWInteractiveTransition.swift
//  YXTransitionAnimate
//
//  Created by 王迪 on 2018/12/29.
//  Copyright © 2018 王迪. All rights reserved.
//

import UIKit

protocol XWInteractiveTransitionDelegate {
    func XWDelegateInteractiveTransition() -> XWInteractiveTransition;
}

class XWInteractiveTransition: UIPercentDrivenInteractiveTransition {
    weak var vc: UIViewController?;
    var interation = false;
    var gestureType = XWInteractiveTransitionGestureDirection.left;
    var animateType = XWInteractiveTransitionType.present;
    var presentConifg : (() -> Void)?;
    
    init(gestureType: XWInteractiveTransitionGestureDirection, animateType: XWInteractiveTransitionType) {
        self.gestureType = gestureType;
        self.animateType = animateType;
        super.init();
    }
    
    func addPanGestureForViewController(vc: UIViewController) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handeleGesture(panGesture:)));
        self.vc = vc;
        self.vc?.view.addGestureRecognizer(pan);
    }
    
    @objc func handeleGesture(panGesture: UIPanGestureRecognizer) {
        
        var persent = 0.0;
        switch gestureType {
        case .left:
            let tX = -panGesture.translation(in: panGesture.view).x;
            persent = Double(tX / (panGesture.view?.frame.width)!);
            break
        case .right:
            let tX = panGesture.translation(in: panGesture.view).x;
            persent = Double(tX / (panGesture.view?.frame.width)!);
            break
        case .up:
            let tX = -panGesture.translation(in: panGesture.view).y;
            persent = Double(tX / (panGesture.view?.frame.width)!);
            break
        case .down:
            let tX = panGesture.translation(in: panGesture.view).y;
            persent = Double(tX / (panGesture.view?.frame.width)!);
            break
        }
        
        switch panGesture.state {
        case .began:
        self.interation = true;
        self.startGesture();
            break
        case .cancelled:
            self.interation = false;
            self.cancel();
            break
        case .changed, .possible:
            
            self.update(CGFloat(persent));
            break
        case .ended:
            self.interation = false;
            if persent > 0.5 {
                self.finish();
            } else {
                self.cancel();
            }
            break
        default:
            break
        }
    }
    func startGesture() {
        if let temp = presentConifg {
            temp();
        } else {
            vc?.dismiss(animated: true, completion: nil);
        }
        
    }
}
enum XWInteractiveTransitionGestureDirection: Int {
    case left = 0, right, up, down;
}
enum XWInteractiveTransitionType: Int {
    case present = 0, dismiss, push, pop;
}
