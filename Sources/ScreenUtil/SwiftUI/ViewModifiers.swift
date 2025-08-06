//
//  ViewModifiers.swift
//  ScreenUtil
//
//  SwiftUI View Modifiers for responsive design
//

#if canImport(SwiftUI)
import SwiftUI
import CoreGraphics

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ResponsiveFrameModifier: ViewModifier {
    private let width: CGFloat?
    private let height: CGFloat?
    private let alignment: Alignment
    
    public init(width: CGFloat?, height: CGFloat?, alignment: Alignment) {
        self.width = width
        self.height = height
        self.alignment = alignment
    }
    
    public func body(content: Content) -> some View {
        content.frame(
            width: width?.w,
            height: height?.h,
            alignment: alignment
        )
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ResponsivePaddingModifier: ViewModifier {
    private let edges: Edge.Set
    private let length: CGFloat
    
    public init(edges: Edge.Set, length: CGFloat) {
        self.edges = edges
        self.length = length
    }
    
    public func body(content: Content) -> some View {
        let scaledLength: CGFloat
        switch edges {
        case .horizontal, .leading, .trailing:
            scaledLength = length.w
        case .vertical, .top, .bottom:
            scaledLength = length.h
        default:
            scaledLength = length.w
        }
        
        return content.padding(edges, scaledLength)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ResponsiveOffsetModifier: ViewModifier {
    private let x: CGFloat
    private let y: CGFloat
    
    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    public func body(content: Content) -> some View {
        content.offset(x: x.w, y: y.h)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ResponsiveCornerRadiusModifier: ViewModifier {
    private let radius: CGFloat
    private let antialiased: Bool
    
    public init(radius: CGFloat, antialiased: Bool) {
        self.radius = radius
        self.antialiased = antialiased
    }
    
    public func body(content: Content) -> some View {
        content.cornerRadius(radius.r, antialiased: antialiased)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ResponsiveShadowModifier: ViewModifier {
    private let color: Color
    private let radius: CGFloat
    private let x: CGFloat
    private let y: CGFloat
    
    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
    
    public func body(content: Content) -> some View {
        content.shadow(color: color, radius: radius.r, x: x.w, y: y.h)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ResponsiveBorderModifier<S: ShapeStyle>: ViewModifier {
    private let content: S
    private let width: CGFloat
    
    public init(content: S, width: CGFloat) {
        self.content = content
        self.width = width
    }
    
    public func body(content: Content) -> some View {
        content.border(self.content, width: width.w)
    }
}


#endif