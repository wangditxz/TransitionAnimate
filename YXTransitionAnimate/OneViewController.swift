//
//  OneViewController.swift
//  YXTransitionAnimate
//
//  Created by 王迪 on 2018/12/26.
//  Copyright © 2018 王迪. All rights reserved.
//

import UIKit

class OneViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var interP : XWInteractiveTransition?;
    var interD : XWInteractiveTransition?;
    var delegate : XWInteractiveTransitionDelegate?;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.purple;
        
        let btn = UIButton(type: .custom);
        btn.setTitle("点击", for: .normal);
        btn.backgroundColor = UIColor.red;
        btn.frame = CGRect(x: 100, y: 100, width: 200, height: 50);
        self.view.addSubview(btn);
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside);
        interD = XWInteractiveTransition(gestureType: .left, animateType: .dismiss);
        interD?.addPanGestureForViewController(vc: self);
        
    }
    
    @objc func btnClick(sender: UIButton) {
        self.dismiss(animated: true, completion: nil);
    }
    
    init() {
        super.init(nibName: nil, bundle: nil);
        self.transitioningDelegate = self;
        
        self.modalPresentationStyle = .custom;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentTransition.transitionWithTransitionType(type: .XWPresentOneTransitionTypeDismiss);
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentTransition.transitionWithTransitionType(type: .XWPresentOneTransitionTypePresent);
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return (interD?.interation)! ? interD : nil;
    }
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        let i = delegate?.XWDelegateInteractiveTransition();
        if (i?.interation)! {
            return i;
        }
        return nil;
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
