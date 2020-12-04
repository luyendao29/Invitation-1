//
//  ToggleViewProtocol.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/4/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

@objc
protocol ToggleViewProtocol: class {
    var controlConstraint: NSLayoutConstraint! {get set}
    var corverButton: UIButton! {get set}
    var menu: UIView! {get set}
//    var effectView: UIVisualEffectView? {get set}
    var closeDistance: CGFloat {get set}
    var showDistance: CGFloat {get set}
    var isOpen: Bool {get set}
    var view: UIView! {get set}
    var coverAlpha: CGFloat {get set}
    
}
extension ToggleViewProtocol {
    
    func performToggle(isOpen: Bool) {
        self.controlConstraint.constant = self.isOpen ? self.showDistance :  -self.closeDistance - 20
        self.corverButton.alpha = self.isOpen ? self.coverAlpha : 0
//        self.effectView?.alpha = self.isOpen ? self.coverAlpha : 0
        UIView.animate(withDuration: 0.35) {
            
            self.view.layoutIfNeeded()
        }
    }
    
    func setupToggleView(distance: CGFloat) {
        closeDistance = distance
        isOpen = false
        setupShowingView()
        controlConstraint.constant =  -closeDistance - 20
        corverButton.alpha = 0
//        effectView?.alpha = 0
        view.layoutIfNeeded()
    }
    
    private func setupShowingView() {
        menu.layer.cornerRadius = 8
        //        menu.shadowColor = UIColor.black
        //        menu.shadowRadius = 20
        //        menu.shadowOpacity = 0.7
        //        menu.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    
}
