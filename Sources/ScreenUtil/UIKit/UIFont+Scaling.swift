//
//  UIFont+Scaling.swift
//  ScreenUtil
//

#if canImport(UIKit)
import UIKit

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

#endif
