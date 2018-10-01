//
//  CustomTransitionController.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/29/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


class CustomTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum TransitionMode: Int {
        case push, pop, dismiss
    }
    
    var transitionMode: TransitionMode
    
    
    let circle = UIView()
    var circleColor = UIColor.white
    var duration = 0.8
    var startingPoint = CGPoint.zero {
        didSet {
            circle.center = startingPoint
        }
    }
    
    
    init(transitionMode: TransitionMode, startingPoint: CGPoint) {
        self.transitionMode = transitionMode
        self.startingPoint = startingPoint
    }
    
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: .to) else { return }
        guard let fromView = transitionContext.view(forKey: .to) else { return }

        
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            print("error getting toVC")
            return
        }
        
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)else {
            print("error getting fromVC")
            return
        }

        
        switch transitionMode {
        case .push:
            
            // get center and size
            let viewCenter = toView.center
            let viewSize = toView.frame.size
            
            // configure circle and add to containerView
            circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
            circle.layer.cornerRadius = circle.frame.size.height / 2
            circle.center = startingPoint
            circle.backgroundColor = circleColor
            circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            containerView.addSubview(circle)
            
            // configure toView and add to containerView
            toView.center = startingPoint
            toView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            containerView.addSubview(toView)
            
            // animation
            UIView.animate(withDuration: duration, animations: {
                self.circle.transform = CGAffineTransform.identity
                toView.transform = CGAffineTransform.identity
            }) { (success) in
                transitionContext.completeTransition(success)
            }
    
            
        case .pop:
            if let returningView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                
                // get center and size
                let viewCenter = returningView.center
                let viewSize = returningView.frame.size
                
                
                toView.superview?.insertSubview(fromView, at: 0)

//                fromView.superview?.insertSubview(toView, at: 0)
//                fromVC.view.superview?.insertSubview(toVC.view, at: 0)
                
                
                // configure circle
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingPoint
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.center = self.startingPoint
                    returningView.alpha = 0
                    
                    // only for .pop
//                    containerView.sendSubviewToBack(returningView)
                    containerView.insertSubview(fromView, belowSubview: returningView)
                    containerView.insertSubview(self.circle, belowSubview: returningView)
                    
                }, completion: { (success:Bool) in
                    print("PRESSED pop")
//                    fromVC.navigationController?.popViewController(animated: true)
//                    fromVC.dismiss(animated: false, completion: nil)
                    transitionContext.completeTransition(success)
                })
            }
            
        case .dismiss:
            if let returningView = transitionContext.view(forKey: UITransitionContextViewKey.from) {
                
                // get center and size
                let viewCenter = returningView.center
                let viewSize = returningView.frame.size
                
                // configure circle
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingPoint
                
                // animation
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.center = self.startingPoint
                    returningView.alpha = 0
                }, completion: { (success:Bool) in
                    print("PRESSED dismiss")
//                    fromVC.dismiss(animated: false, completion: nil)
                })
            }
            
        }
        
    }
    
    
    func frameForCircle (withViewCenter viewCenter:CGPoint, size viewSize:CGSize, startPoint:CGPoint) -> CGRect {
        
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        let offestVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offestVector, height: offestVector)
        return CGRect(origin: CGPoint.zero, size: size)
        
    }
    
}
