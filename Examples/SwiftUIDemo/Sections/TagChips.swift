//
//  TagChips.swift
//  ScreenUtil Examples
//
//  Topic chips whose widths/corner radii are batch-scaled.
//  Created by Dicky Darmawan on 27/06/26.
//

import ScreenUtil
import SwiftUI

struct TagChips: View {
    let tags: [String]

    var body: some View {
        // Bulk example: scale a uniform corner radius + min width for every chip.
        let radii = ScreenUtil.shared.batchScaler.radii(Array(repeating: 12, count: tags.count))
        let widths = withBatchScaler { $0.widths(Array(repeating: 64, count: tags.count)) }
        HStack {
            ForEach(Array(tags.enumerated()), id: \.offset) { index, tag in
                Text(tag)
                    .font(.system(size: 13.sp, weight: .medium))
                    .padding(.horizontal, 12.w)
                    .padding(.vertical, 6.h)
                    .frame(minWidth: widths[index])
                    .background(.tint.opacity(0.15), in: .rect(cornerRadius: radii[index]))
            }
        }
    }
}
