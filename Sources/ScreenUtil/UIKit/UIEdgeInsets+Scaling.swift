//
//  UIEdgeInsets+Scaling.swift
//  ScreenUtil
//

#if canImport(UIKit)
import UIKit

public extension UIEdgeInsets {
    /// Create scaled insets from explicit design values.
    static func scaled(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: top.h, left: left.w, bottom: bottom.h, right: right.w)
    }

    /// Create uniformly scaled insets.
    static func scaled(all: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: all.h, left: all.w, bottom: all.h, right: all.w)
    }

    /// Create horizontally and vertically scaled insets.
    static func scaled(horizontal: CGFloat, vertical: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: vertical.h, left: horizontal.w, bottom: vertical.h, right: horizontal.w)
    }
}

#endif
