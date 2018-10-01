//
//  CustomNavigationController.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/29/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//


import UIKit

class CustomNavigationController: UINavigationController {
    
    private var interactionController: UIPercentDrivenInteractiveTransition?
    
    private var edgeSwipeGestureRecognizer: UIScreenEdgePanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        addSwipeGestureLeft()
    }
    
    // SWIPE
    func addSwipeGestureLeft(){
        edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        edgeSwipeGestureRecognizer!.edges = .left
        view.addGestureRecognizer(edgeSwipeGestureRecognizer!)
    }
    
    @objc func handleSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let percent = gestureRecognizer.translation(in: gestureRecognizer.view!).x / gestureRecognizer.view!.bounds.size.width
        
        if gestureRecognizer.state == .began {
            interactionController = UIPercentDrivenInteractiveTransition()
            popViewController(animated: true)
        } else if gestureRecognizer.state == .changed {
            interactionController?.update(percent)
        } else if gestureRecognizer.state == .ended {
            if percent > 0.5 && gestureRecognizer.state != .cancelled {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
    
}



extension CustomNavigationController: UINavigationControllerDelegate {
    
    enum TransitionMode: Int {
        case push, pop, dismiss
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            return CustomTransitionController(transitionMode: .push, startingPoint: toVC.view.center)
        }
        else {
            return CustomTransitionController(transitionMode: .pop, startingPoint: fromVC.view.center)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}
