//
//  View+Responsive.swift
//  ScreenUtil
//
//  SwiftUI view, font, and environment support
//  Created by Dicky Darmawan on 06/06/26.
//

#if canImport(SwiftUI)
import SwiftUI

// MARK: - View Modifiers

public extension View {
    /// Apply a responsive frame (design values scaled to the device).
    func responsiveFrame(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some View {
        self.frame(width: width?.w, height: height?.h, alignment: alignment)
    }

    /// Apply responsive padding to an edge set.
    func responsivePadding(_ edges: Edge.Set = .all, _ length: CGFloat) -> some View {
        self.padding(edges, edges.isHorizontal ? length.w : length.h)
    }

    /// Apply responsive padding from design insets.
    func responsivePadding(_ insets: EdgeInsets) -> some View {
        self.padding(EdgeInsets(
            top: insets.top.h,
            leading: insets.leading.w,
            bottom: insets.bottom.h,
            trailing: insets.trailing.w
        ))
    }

    /// Apply a scaled corner radius.
    func responsiveCornerRadius(_ radius: CGFloat) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: radius.r, style: .continuous))
    }
}

// MARK: - Font

public extension Font {
    /// Create a system font with scaled size.
    static func scaledSystem(
        size: CGFloat,
        weight: Font.Weight = .regular,
        design: Font.Design = .default
    ) -> Font {
        return .system(size: size.sp, weight: weight, design: design)
    }

    /// Create a custom font with scaled size.
    static func scaledCustom(_ name: String, size: CGFloat) -> Font {
        return .custom(name, size: size.sp)
    }
}

// MARK: - Environment

private struct ScreenUtilKey: EnvironmentKey {
    static let defaultValue: ScreenUtil = .shared
}

public extension EnvironmentValues {
    /// Access ScreenUtil instance from environment.
    var screenUtil: ScreenUtil {
        get { self[ScreenUtilKey.self] }
        set { self[ScreenUtilKey.self] = newValue }
    }
}

// MARK: - Helpers

private extension Edge.Set {
    var isHorizontal: Bool {
        return self == .horizontal || self == .leading || self == .trailing
    }
}

#endif
