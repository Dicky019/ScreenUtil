//
//  UIView+Scaling.swift
//  ScreenUtil
//
//  UIView constraint and styling scaling helpers
//  Created by Dicky Darmawan on 06/06/26.
//

#if canImport(UIKit)
import UIKit

public extension UIView {
    /// Apply width constraint with scaling
    @discardableResult
    func width(_ constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self.widthAnchor.constraint(equalToConstant: constant.w)
        constraint.isActive = true
        return constraint
    }

    /// Apply height constraint with scaling
    @discardableResult
    func height(_ constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self.heightAnchor.constraint(equalToConstant: constant.h)
        constraint.isActive = true
        return constraint
    }

    /// Apply size constraints with scaling
    @discardableResult
    func size(width: CGFloat, height: CGFloat) -> [NSLayoutConstraint] {
        let constraints = [
            self.widthAnchor.constraint(equalToConstant: width.w),
            self.heightAnchor.constraint(equalToConstant: height.h)
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /// Set corner radius with scaling
    func cornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius.r
    }

    /// Set border width with scaling
    func borderWidth(_ width: CGFloat) {
        self.layer.borderWidth = width.w
    }
}

public extension NSLayoutConstraint {
    /// Update constraint constant with scaling, picking width/height axis from the attribute.
    func updateConstant(_ constant: CGFloat) {
        switch firstAttribute {
        case .width, .leading, .trailing, .left, .right, .centerX:
            self.constant = constant.w
        case .height, .top, .bottom, .centerY:
            self.constant = constant.h
        default:
            self.constant = constant.w
        }
    }
}

#endif
