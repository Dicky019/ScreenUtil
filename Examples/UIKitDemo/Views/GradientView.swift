//
//  GradientView.swift
//  ScreenUtil Examples
//
//  A UIView whose backing layer is a CAGradientLayer, so the gradient resizes with
//  the view automatically (no layoutSubviews bookkeeping). UIKit's counterpart to
//  SwiftUI's LinearGradient / Color.gradient.
//  Created by Dicky Darmawan on 27/06/26.
//

import UIKit

final class GradientView: UIView {
    override class var layerClass: AnyClass { CAGradientLayer.self }
    private var gradient: CAGradientLayer { layer as! CAGradientLayer }

    /// `colors` resolve to CGColors at init — fine here because the demo gradients use
    /// fixed system hues (matching SwiftUI's non-semantic `.blue`/`.purple`), which the
    /// SwiftUI side doesn't adapt for dark mode either. ponytail: add trait re-resolve
    /// only if these ever become semantic colors.
    init(colors: [UIColor],
         start: CGPoint = CGPoint(x: 0, y: 0),
         end: CGPoint = CGPoint(x: 1, y: 1)) {
        super.init(frame: .zero)
        
        gradient.colors = colors.map(\.cgColor)
        gradient.startPoint = start
        gradient.endPoint = end
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
