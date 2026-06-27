//
//  DemoApp.swift
//  ScreenUtil Examples
//
//  SwiftUI showcase entry point — configures the ScreenUtil scale baseline at launch.
//  Created by Dicky Darmawan on 27/06/26.
//

import ScreenUtil
import SwiftUI

@main
struct DemoApp: App {
    init() {
        // Design baseline: iPhone 12 (390×844). iPhone 12 renders 1:1; larger devices scale up.
        // A single configure() suffices: ScreenUtil's scene-activate observer rebuilds the
        // metrics snapshot once the window exists, and ProfileViewModel publishes it after load.
        ScreenUtil.shared.configure(with: .iPhone12)
    }

    var body: some Scene {
        WindowGroup { ProfileView() }
    }
}
