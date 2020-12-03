//
//  UIView.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 11/26/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    static func nibName() -> String {
        let nameSpaceClassName = NSStringFromClass(self)
        let className = nameSpaceClassName.components(separatedBy: ".").last! as String
        return className
    }
    
    static func nib() -> UINib {
        return UINib(nibName: self.nibName(), bundle: nil)
    }
    
    static func loadFromNib<T: UIView>() -> T {
        let nameStr = "\(self)"
        let arrName = nameStr.split { $0 == "." }
        let nibName = arrName.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! T
    }
    func fill(left: CGFloat? = 0, top: CGFloat? = 0, right: CGFloat? = 0, bottom: CGFloat? = 0) {
        guard let superview = superview else {
            print("\(self.description): there is no superView")
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        if let left = left {
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: left).isActive = true
        }
        if let top = top  {
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        }
        
        if let right = right {
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -right).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom).isActive = true
        }
    }
}
