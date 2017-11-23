//
//  DismissAnimator.swift
//  BouncyPresent
//
//  Created by Sayantan Chakraborty on 08/08/17.
//  Copyright © 2017 ShinobiControls. All rights reserved.
//

import UIKit

class DismissAnimator: NSObject{
    
}

extension DismissAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let containerView:UIView = transitionContext.containerView
            else {
                return
        }
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fromVC.view.frame = finalFrame
                toVC.view.transform =  CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        },
            completion: { _ in
                
                //fromVC.view.removeFromSuperview()
                print(transitionContext.transitionWasCancelled)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                //transitionContext.completeTransition(false)
        }
        )
    }
}
