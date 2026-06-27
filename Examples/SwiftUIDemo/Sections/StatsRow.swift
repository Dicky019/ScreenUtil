//
//  StatsRow.swift
//  ScreenUtil Examples
//
//  Repos / followers / following, sized in bulk via BatchScaler.
//  Created by Dicky Darmawan on 27/06/26.
//

import ScreenUtil
import SwiftUI

struct StatsRow: View {
    let profile: Profile

    // `label` is unique per row, so it doubles as a stable ForEach identity.
    private struct Stat: Identifiable { let value: Int; let label: String; var id: String { label } }
    private var stats: [Stat] {
        [.init(value: profile.repos, label: "Repos"),
         .init(value: profile.followers, label: "Followers"),
         .init(value: profile.following, label: "Following")]
    }

    var body: some View {
        // Bulk-scale the two font sizes once, then reuse per column.
        let sizes = ScreenUtil.shared.batchScaler.fontSizes([22, 13])
        
        HStack {
            ForEach(stats) { stat in
                VStack(spacing: 2.h) {
                    Text(stat.value.compactText)
                        .font(.system(size: sizes[0], weight: .bold))
                    Text(stat.label)
                        .font(.system(size: sizes[1]))
                        .foregroundStyle(.secondaryText)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 14.h)
        .background(.card, in: .rect(cornerRadius: 16.r))
    }
}
