//
//  PropertyWrappers.swift
//  ScreenUtil
//
//  SwiftUI Property Wrappers for responsive design
//

#if canImport(SwiftUI)
import SwiftUI
import CoreGraphics


@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct ResponsiveWidth {
    private let designValue: CGFloat
    
    public init(wrappedValue: CGFloat) {
        self.designValue = wrappedValue
    }
    
    public var wrappedValue: CGFloat {
        return designValue.w
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct ResponsiveHeight {
    private let designValue: CGFloat
    
    public init(wrappedValue: CGFloat) {
        self.designValue = wrappedValue
    }
    
    public var wrappedValue: CGFloat {
        return designValue.h
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct ResponsiveFontSize {
    private let designValue: CGFloat
    
    public init(wrappedValue: CGFloat) {
        self.designValue = wrappedValue
    }
    
    public var wrappedValue: CGFloat {
        return designValue.sp
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct ResponsiveRadius {
    private let designValue: CGFloat
    
    public init(wrappedValue: CGFloat) {
        self.designValue = wrappedValue
    }
    
    public var wrappedValue: CGFloat {
        return designValue.r
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct ResponsiveSize {
    private let designSize: CGSize
    
    public init(wrappedValue: CGSize) {
        self.designSize = wrappedValue
    }
    
    public var wrappedValue: CGSize {
        return CGSize(width: designSize.width.w, height: designSize.height.h)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct ResponsiveEdgeInsets {
    private let designInsets: EdgeInsets
    
    public init(wrappedValue: EdgeInsets) {
        self.designInsets = wrappedValue
    }
    
    public var wrappedValue: EdgeInsets {
        return EdgeInsets(
            top: designInsets.top.h,
            leading: designInsets.leading.w,
            bottom: designInsets.bottom.h,
            trailing: designInsets.trailing.w
        )
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct FastScaledValue {
    private let designValue: CGFloat
    private let scaleType: ScaleType
    
    public init(wrappedValue: CGFloat, _ scaleType: ScaleType = .width) {
        self.designValue = wrappedValue
        self.scaleType = scaleType
    }
    
    public var wrappedValue: CGFloat {
        return ScreenUtil.shared.fastScale(for: designValue, scaleType: scaleType)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct ScreenPercentage {
    private let percentage: CGFloat
    private let dimension: Dimension
    
    public enum Dimension {
        case width
        case height
    }
    
    public init(wrappedValue: CGFloat, _ dimension: Dimension) {
        self.percentage = wrappedValue
        self.dimension = dimension
    }
    
    public var wrappedValue: CGFloat {
        switch dimension {
        case .width:
            return percentage.sw
        case .height:
            return percentage.sh
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct ResponsiveFont {
    private let size: CGFloat
    private let weight: Font.Weight
    private let design: Font.Design
    
    public init(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) {
        self.size = size
        self.weight = weight
        self.design = design
    }
    
    public var wrappedValue: Font {
        return .system(size: size.sp, weight: weight, design: design)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct ResponsiveCustomFont {
    private let name: String
    private let size: CGFloat
    
    public init(name: String, size: CGFloat) {
        self.name = name
        self.size = size
    }
    
    public var wrappedValue: Font {
        return .custom(name, size: size.sp)
    }
}

#endif