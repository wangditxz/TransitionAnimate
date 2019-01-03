//
//  PresentTransition.swift
//  YXTransitionAnimate
//
//  Created by 王迪 on 2018/12/26.
//  Copyright © 2018 王迪. All rights reserved.
//

import UIKit

class PresentTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var type:XWPresentOneTransitionType = XWPresentOneTransitionType.XWPresentOneTransitionTypePresent;
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5;
    }
    
    static func transitionWithTransitionType(type: XWPresentOneTransitionType) -> PresentTransition {
        let obj = PresentTransition();
        obj.type = type;
        return obj;
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch type {
        case .XWPresentOneTransitionTypeDismiss:
            self.dismissAnimation(using: transitionContext);
        case .XWPresentOneTransitionTypePresent:
            self.presentAnimation(using: transitionContext);
        }
    }
    
    private func presentAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        let toVc = transitionContext.viewController(forKey: .to);
        let fromVc = transitionContext.viewController(forKey: .from);
        // 准备工作
        let tempView = fromVc?.view.snapshotView(afterScreenUpdates: false);
        tempView?.frame = (fromVc?.view.frame)!;
        fromVc?.view.isHidden = true;
        
        // containerView
        let containerView = transitionContext.containerView;
        
        containerView.addSubview(tempView!);
        containerView.addSubview((toVc?.view)!);
        let frame = containerView.frame;
        toVc?.view.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: frame.height);
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 1.0 / 0.55, options: .allowAnimatedContent, animations: {
            toVc?.view.transform = CGAffineTransform(translationX: 0, y: -frame.height);
            tempView?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85);
        }) { (finished) in
            //使用如下代码标记整个转场过程是否正常完成[transitionContext transitionWasCancelled]代表手势是否取消了，如果取消了就传NO表示转场失败，反之亦然，如果不用手势present的话直接传YES也是可以的，但是无论如何我们都必须标记转场的状态，系统才知道处理转场后的操作，否者认为你一直还在转场中，会出现无法交互的情况，切记！
            transitionContext.completeTransition(transitionContext.transitionWasCancelled == false);
            if (transitionContext.transitionWasCancelled) {
                fromVc?.view.isHidden = false;
                tempView?.removeFromSuperview();
            }
        };
        
    }
    
    private func dismissAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVc = transitionContext.viewController(forKey: .from);
        let toVc = transitionContext.viewController(forKey: .to);
        
        let tempView = transitionContext.containerView.subviews[0];
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 1.0 / 0.55, options: .allowAnimatedContent, animations: {
            fromVc?.view.transform = .identity;
            tempView.transform = .identity;
        }) { (finished: Bool) in
            if transitionContext.transitionWasCancelled {
                transitionContext.completeTransition(false);
            } else {
                transitionContext.completeTransition(true);
                toVc?.view.isHidden = false;
                tempView.removeFromSuperview();
            }
        };
    }
}
enum XWPresentOneTransitionType: Int {
    case XWPresentOneTransitionTypePresent = 0, XWPresentOneTransitionTypeDismiss
}
