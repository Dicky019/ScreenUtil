//
//  SafeScalingExtensions.swift
//  ScreenUtil
//
//  Platform-independent safe scaling extensions
//

import Foundation
import CoreGraphics
#if canImport(SwiftUI)
import SwiftUI
#endif

public extension CGSize {
    @inline(__always)
    func scaled(for screenUtil: ScreenUtil = .shared) -> CGSize {
        return CGSize(
            width: screenUtil.w(width),
            height: screenUtil.h(height)
        )
    }
    
    @inline(__always)
    static func responsive(width: CGFloat, height: CGFloat) -> CGSize {
        return CGSize(width: width.w, height: height.h)
    }
    
    @inline(__always)
    func fastScaled() -> CGSize {
        let fastScale = ScreenUtil.shared.fastScale
        return fastScale.size(self)
    }
}

public extension CGPoint {
    @inline(__always)
    func scaled(for screenUtil: ScreenUtil = .shared) -> CGPoint {
        return CGPoint(
            x: screenUtil.w(x),
            y: screenUtil.h(y)
        )
    }
    
    @inline(__always)
    static func responsive(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: x.w, y: y.h)
    }
    
    @inline(__always)
    func fastScaled() -> CGPoint {
        let fastScale = ScreenUtil.shared.fastScale
        return fastScale.point(self)
    }
}

public extension CGRect {
    @inline(__always)
    func scaled(for screenUtil: ScreenUtil = .shared) -> CGRect {
        return CGRect(
            x: screenUtil.w(origin.x),
            y: screenUtil.h(origin.y),
            width: screenUtil.w(size.width),
            height: screenUtil.h(size.height)
        )
    }
    
    @inline(__always)
    static func responsive(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: x.w, y: y.h, width: width.w, height: height.h)
    }
    
    @inline(__always)
    func fastScaled() -> CGRect {
        let fastScale = ScreenUtil.shared.fastScale
        return fastScale.rect(self)
    }
}

// Platform-independent insets structure
public struct ResponsiveInsets: Sendable {
    public let top: CGFloat
    public let leading: CGFloat
    public let bottom: CGFloat
    public let trailing: CGFloat
    
    public init(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }
    
    @inline(__always)
    public static func responsive(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) -> ResponsiveInsets {
        return ResponsiveInsets(
            top: top.h,
            leading: leading.w,
            bottom: bottom.h,
            trailing: trailing.w
        )
    }
    
    @inline(__always)
    public static func responsiveSymmetric(horizontal: CGFloat, vertical: CGFloat) -> ResponsiveInsets {
        return ResponsiveInsets(
            top: vertical.h,
            leading: horizontal.w,
            bottom: vertical.h,
            trailing: horizontal.w
        )
    }
    
    @inline(__always)
    public static func responsiveAll(_ value: CGFloat) -> ResponsiveInsets {
        return ResponsiveInsets(
            top: value.h,
            leading: value.w,
            bottom: value.h,
            trailing: value.w
        )
    }
    
    #if canImport(UIKit)
    public var uiEdgeInsets: UIEdgeInsets {
        return UIEdgeInsets(top: top, left: leading, bottom: bottom, right: trailing)
    }
    #endif
    
    #if canImport(SwiftUI)
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public var edgeInsets: SwiftUI.EdgeInsets {
        return SwiftUI.EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    #endif
}

// Cross-platform font scaling utilities
public struct ResponsiveFontDescriptor: Sendable {
    public let size: CGFloat
    public let weight: FontWeight
    
    public enum FontWeight: Sendable {
        case ultraLight
        case thin
        case light
        case regular
        case medium
        case semibold
        case bold
        case heavy
        case black
        
        #if canImport(UIKit)
        public var uiFontWeight: UIFont.Weight {
            switch self {
            case .ultraLight: return .ultraLight
            case .thin: return .thin
            case .light: return .light
            case .regular: return .regular
            case .medium: return .medium
            case .semibold: return .semibold
            case .bold: return .bold
            case .heavy: return .heavy
            case .black: return .black
            }
        }
        #endif
        
        #if canImport(SwiftUI)
        @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
        public var swiftUIFontWeight: SwiftUI.Font.Weight {
            switch self {
            case .ultraLight: return .ultraLight
            case .thin: return .thin
            case .light: return .light
            case .regular: return .regular
            case .medium: return .medium
            case .semibold: return .semibold
            case .bold: return .bold
            case .heavy: return .heavy
            case .black: return .black
            }
        }
        #endif
    }
    
    public init(size: CGFloat, weight: FontWeight = .regular) {
        self.size = size.sp
        self.weight = weight
    }
    
    #if canImport(UIKit)
    public var uiFont: UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight.uiFontWeight)
    }
    #endif
    
    #if canImport(SwiftUI)
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public var swiftUIFont: SwiftUI.Font {
        return SwiftUI.Font.system(size: size, weight: weight.swiftUIFontWeight)
    }
    #endif
}