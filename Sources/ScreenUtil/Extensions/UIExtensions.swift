//
//  UIExtensions.swift
//  ScreenUtil
//
//  Copyright © 2025 Dicky Darmawan. All rights reserved.
//

#if canImport(UIKit)
import UIKit

// MARK: - UIFont Extension

public extension UIFont {
    /// Create a system font with scaled size
    /// - Parameters:
    ///   - size: Design font size
    ///   - weight: Font weight
    ///   - scaled: Whether to apply scaling (default: true)
    /// - Returns: Scaled UIFont
    static func systemFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular, scaled: Bool = true) -> UIFont {
        let scaledSize = scaled ? size.sp : size
        return UIFont.systemFont(ofSize: scaledSize, weight: weight)
    }
    
    /// Create a custom font with scaled size
    /// - Parameters:
    ///   - name: Font name
    ///   - size: Design font size
    ///   - scaled: Whether to apply scaling (default: true)
    /// - Returns: Scaled UIFont if font exists, nil otherwise
    static func customFont(name: String, size: CGFloat, scaled: Bool = true) -> UIFont? {
        let scaledSize = scaled ? size.sp : size
        return UIFont(name: name, size: scaledSize)
    }
    
    /// Get a scaled version of the current font
    /// - Parameter scaled: Whether to apply scaling (default: true)
    /// - Returns: Scaled font
    func scaled(_ scaled: Bool = true) -> UIFont {
        let newSize = scaled ? pointSize.sp : pointSize
        return self.withSize(newSize)
    }
}

// MARK: - UIView Extension

public extension UIView {
    /// Apply width constraint with scaling
    /// - Parameter constant: Design width value
    /// - Returns: Created constraint
    @discardableResult
    func width(_ constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self.widthAnchor.constraint(equalToConstant: constant.w)
        constraint.isActive = true
        return constraint
    }
    
    /// Apply height constraint with scaling
    /// - Parameter constant: Design height value
    /// - Returns: Created constraint
    @discardableResult
    func height(_ constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self.heightAnchor.constraint(equalToConstant: constant.h)
        constraint.isActive = true
        return constraint
    }
    
    /// Apply size constraints with scaling
    /// - Parameters:
    ///   - width: Design width value
    ///   - height: Design height value
    /// - Returns: Array of created constraints
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
    /// - Parameter radius: Design radius value
    func cornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius.r
    }
    
    /// Set border width with scaling
    /// - Parameter width: Design border width
    func borderWidth(_ width: CGFloat) {
        self.layer.borderWidth = width.w
    }
}

// MARK: - UIEdgeInsets Extension

public extension UIEdgeInsets {
    /// Create scaled insets
    /// - Parameters:
    ///   - top: Top inset design value
    ///   - left: Left inset design value
    ///   - bottom: Bottom inset design value
    ///   - right: Right inset design value
    /// - Returns: Scaled UIEdgeInsets
    static func scaled(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: top.h,
            left: left.w,
            bottom: bottom.h,
            right: right.w
        )
    }
    
    /// Create uniformly scaled insets
    /// - Parameter all: Uniform inset design value
    /// - Returns: Scaled UIEdgeInsets
    static func scaled(all: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: all.h,
            left: all.w,
            bottom: all.h,
            right: all.w
        )
    }
    
    /// Create horizontally and vertically scaled insets
    /// - Parameters:
    ///   - horizontal: Horizontal inset design value
    ///   - vertical: Vertical inset design value
    /// - Returns: Scaled UIEdgeInsets
    static func scaled(horizontal: CGFloat, vertical: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: vertical.h,
            left: horizontal.w,
            bottom: vertical.h,
            right: horizontal.w
        )
    }
}

// MARK: - CGSize Extension

public extension CGSize {
    /// Create a scaled size
    /// - Parameters:
    ///   - width: Design width value
    ///   - height: Design height value
    /// - Returns: Scaled CGSize
    static func scaled(width: CGFloat, height: CGFloat) -> CGSize {
        return CGSize(width: width.w, height: height.h)
    }
    
    /// Get scaled version of current size
    var scaled: CGSize {
        return CGSize(width: width.w, height: height.h)
    }
}

// MARK: - CGPoint Extension

public extension CGPoint {
    /// Create a scaled point
    /// - Parameters:
    ///   - x: Design x value
    ///   - y: Design y value
    /// - Returns: Scaled CGPoint
    static func scaled(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: x.w, y: y.h)
    }
    
    /// Get scaled version of current point
    var scaled: CGPoint {
        return CGPoint(x: x.w, y: y.h)
    }
}

// MARK: - CGRect Extension

public extension CGRect {
    /// Create a scaled rectangle
    /// - Parameters:
    ///   - x: Design x value
    ///   - y: Design y value
    ///   - width: Design width value
    ///   - height: Design height value
    /// - Returns: Scaled CGRect
    static func scaled(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: x.w, y: y.h, width: width.w, height: height.h)
    }
    
    /// Get scaled version of current rectangle
    var scaled: CGRect {
        return CGRect(x: origin.x.w, y: origin.y.h, width: size.width.w, height: size.height.h)
    }
}

// MARK: - NSLayoutConstraint Extension

public extension NSLayoutConstraint {
    /// Update constraint constant with scaling
    /// - Parameter constant: Design constant value
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