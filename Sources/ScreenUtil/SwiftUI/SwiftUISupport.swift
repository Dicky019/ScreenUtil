//
//  SwiftUISupport.swift
//  ScreenUtil
//
//  Copyright © 2024 ScreenUtil. All rights reserved.
//

import SwiftUI

// MARK: - SwiftUI View Extensions

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension View {
    /// Apply responsive frame to a view
    /// - Parameters:
    ///   - width: Design width value (optional)
    ///   - height: Design height value (optional)
    ///   - alignment: Frame alignment (default: .center)
    /// - Returns: Modified view with scaled frame
    func responsiveFrame(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some View {
        self.frame(
            width: width?.w,
            height: height?.h,
            alignment: alignment
        )
    }
    
    /// Apply responsive padding
    /// - Parameters:
    ///   - edges: Edge set to apply padding
    ///   - length: Design padding value
    /// - Returns: Modified view with scaled padding
    func responsivePadding(_ edges: Edge.Set = .all, _ length: CGFloat) -> some View {
        self.padding(edges, edges.isHorizontal ? length.w : length.h)
    }
    
    /// Apply responsive padding with custom insets
    /// - Parameter insets: Design edge insets
    /// - Returns: Modified view with scaled padding
    func responsivePadding(_ insets: EdgeInsets) -> some View {
        self.padding(EdgeInsets(
            top: insets.top.h,
            leading: insets.leading.w,
            bottom: insets.bottom.h,
            trailing: insets.trailing.w
        ))
    }
    
    /// Apply responsive corner radius
    /// - Parameter radius: Design radius value
    /// - Returns: Modified view with scaled corner radius
    func responsiveCornerRadius(_ radius: CGFloat) -> some View {
        self.cornerRadius(radius.r)
    }
}

// MARK: - Font Extension

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@MainActor
public extension Font {
    /// Create a system font with scaled size
    /// - Parameters:
    ///   - size: Design font size
    ///   - weight: Font weight (default: .regular)
    ///   - design: Font design (default: .default)
    /// - Returns: Scaled font
    static func scaledSystem(
        size: CGFloat,
        weight: Font.Weight = .regular,
        design: Font.Design = .default
    ) -> Font {
        return .system(size: size.sp, weight: weight, design: design)
    }
    
    /// Create a custom font with scaled size
    /// - Parameters:
    ///   - name: Font name
    ///   - size: Design font size
    /// - Returns: Scaled custom font
    static func scaledCustom(_ name: String, size: CGFloat) -> Font {
        return .custom(name, size: size.sp)
    }
}

// MARK: - Environment Key

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@MainActor
private struct ScreenUtilKey: @preconcurrency EnvironmentKey {
    static let defaultValue = ScreenUtil.shared
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension EnvironmentValues {
    /// Access ScreenUtil instance from environment
    var screenUtil: ScreenUtil {
        get { self[ScreenUtilKey.self] }
        set { self[ScreenUtilKey.self] = newValue }
    }
}

// MARK: - Property Wrappers

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
/// Property wrapper for scaled values
@propertyWrapper
public struct ScaledValue {
    private let value: CGFloat
    private let type: ScaleType
    
    /// Scale type for the value
    public enum ScaleType {
        case width
        case height
        case font
        case radius
        case auto
    }
    
    /// Initialize with value and scale type
    /// - Parameters:
    ///   - wrappedValue: Design value
    ///   - type: Scale type (default: .auto)
    public init(wrappedValue: CGFloat, _ type: ScaleType = .auto) {
        self.value = wrappedValue
        self.type = type
    }
    
    /// Get the scaled value
    @MainActor
    public var wrappedValue: CGFloat {
        switch type {
        case .width:
            return value.w
        case .height:
            return value.h
        case .font:
            return value.sp
        case .radius:
            return value.r
        case .auto:
            // Currently defaults to width scaling
            return value.w
        }
    }
}

// MARK: - ViewModifiers

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
/// ViewModifier for responsive frame
public struct ResponsiveFrame: ViewModifier {
    let width: CGFloat?
    let height: CGFloat?
    let alignment: Alignment
    
    public func body(content: Content) -> some View {
        content
            .frame(
                width: width?.w,
                height: height?.h,
                alignment: alignment
            )
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
/// ViewModifier for responsive padding
public struct ResponsivePadding: ViewModifier {
    let edges: Edge.Set
    let length: CGFloat
    
    public func body(content: Content) -> some View {
        content.padding(edges, edges.isHorizontal ? length.w : length.h)
    }
}

// MARK: - Helper Extensions

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
private extension Edge.Set {
    var isHorizontal: Bool {
        return self == .horizontal || self == .leading || self == .trailing
    }
    
    var isVertical: Bool {
        return self == .vertical || self == .top || self == .bottom
    }
}

// MARK: - Preview Support

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
/// Helper for creating previews with different device sizes
public struct ScreenUtilPreview<Content: View>: View {
    let content: Content
    let devices: [(name: String, size: CGSize)]
    
    public init(
        @ViewBuilder content: () -> Content,
        devices: [(name: String, size: CGSize)] = [
            ("iPhone SE", CGSize(width: 375, height: 667)),
            ("iPhone 14", CGSize(width: 390, height: 844)),
            ("iPhone 14 Pro Max", CGSize(width: 428, height: 926)),
            ("iPad Pro 11\"", CGSize(width: 834, height: 1194))
        ]
    ) {
        self.content = content()
        self.devices = devices
    }
    
    public var body: some View {
        ForEach(devices, id: \.name) { device in
            content
                .previewDevice(PreviewDevice(rawValue: device.name))
                .previewDisplayName(device.name)
        }
    }
}