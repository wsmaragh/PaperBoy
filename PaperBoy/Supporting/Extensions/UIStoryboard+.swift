//
//  UIStoryboard+.swift
//  PaperBoy
//
//  Created by winston on 1/2/19.
//  Copyright © 2019 Winston Maragh. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }
    
    enum Storyboard: String {
        case Main
        var instance: UIStoryboard { return UIStoryboard(name: self.rawValue, bundle: Bundle.main) }
    }
    
    /// e.g. surveyStoryboard.instantiate(SurveyIntroViewController.self)
    func instantiate<T>(_ viewControllerType: T.Type) -> T where T: UIViewController {
        guard let ret = instantiateViewController(withIdentifier: viewControllerType.identifier) as? T else {
            fatalError()
        }
        return ret
    }
    
}
