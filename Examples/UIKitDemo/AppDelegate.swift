//
//  AppDelegate.swift
//  ScreenUtil Examples
//
//  UIKit demo entry point.
//  Created by Dicky Darmawan on 21/06/26.
//

import ScreenUtil
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Design baseline: iPhone 12 (390×844). On iPhone 12 every value renders 1:1;
        // on larger devices (e.g. iPhone 17 Pro Max) the whole UI scales up proportionally.
        // A single configure() suffices: ScreenUtil's scene-activate observer rebuilds the
        // metrics snapshot once the window exists, and loadUser rebuilds the sections after.
        ScreenUtil.shared.configure(with: .iPhone12)
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }
}
