//
//  DeviceCard.swift
//  ScreenUtil Examples
//
//  "Device & scaling" card — surfaces metrics + the explicit scaling entry points.
//  Created by Dicky Darmawan on 27/06/26.
//

import ScreenUtil
import SwiftUI

struct DeviceCard: View {
    // Driving the card off observable state (passed in) is what makes SwiftUI re-render it
    // when metrics change — reading ScreenUtil imperatively alone would never invalidate the view.
    let metrics: ScreenMetrics

    // Read ScreenUtil from the environment (default value is `.shared`).
    @Environment(\.screenUtil) private var screenUtil

    var body: some View {
        VStack(alignment: .leading, spacing: 8.h) {
            Text("Device & Scaling")
                .font(.system(size: 17.sp, weight: .semibold))

            ForEach(DeviceMetricsRows.make(metrics: metrics, scaling: screenUtil)) { item in
                row(item.label, item.value)
            }
        }
        .padding(16.w)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.card, in: .rect(cornerRadius: 16.r))
    }

    private func row(_ key: String, _ value: String) -> some View {
        HStack {
            Text(key).foregroundStyle(.secondaryText)
            Spacer()
            Text(value).fontWeight(.medium)
        }
        .font(.system(size: 13.sp))
    }
}
