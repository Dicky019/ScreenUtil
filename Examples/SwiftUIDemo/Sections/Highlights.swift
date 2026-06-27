//
//  Highlights.swift
//  ScreenUtil Examples
//
//  Horizontal "highlights" strip built in a loop with a captured FastScale.
//  Created by Dicky Darmawan on 27/06/26.
//

import ScreenUtil
import SwiftUI

struct Highlights: View {
    private let titles = ExampleProfile.highlights

    var body: some View {
        // Capture scale factors once for the repeated circles (hot path).
        let fast = ScreenUtil.shared.fastScale
        let diameter = fast.width(64)
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: fast.width(14)) {
                ForEach(titles, id: \.self) { title in
                    VStack(spacing: fast.height(6)) {
                        Circle()
                            .fill(LinearGradient(colors: Color.accentColors, startPoint: .top, endPoint: .bottom))
                            .frame(width: diameter, height: diameter)
                            .overlay(Text(title.prefix(1)).font(.system(size: fast.text(24), weight: .bold)).foregroundStyle(.onAccent))
                        Text(title).font(.system(size: fast.text(12)))
                    }
                }
            }
        }
        // Full-bleed carousel: the caller cancels the page's 20pt padding so the
        // scroll track reaches the screen edges; this re-insets the *content* by
        // the same 20pt, so the first circle still lines up with the other rows
        // and items scroll edge-to-edge instead of being clipped by the padding.
        .contentMargins(.horizontal, 20.w, for: .scrollContent)
    }
}
