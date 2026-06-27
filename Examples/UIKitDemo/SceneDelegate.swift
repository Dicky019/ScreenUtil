//
//  SceneDelegate.swift
//  ScreenUtil Examples
//
//  Scene setup: installs the root profile screen.
//  Created by Dicky Darmawan on 21/06/26.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        // No navigation controller: the profile header already shows the identity, so
        // the demo matches the SwiftUI version (no title bar). The scroll view insets
        // its content below the status bar automatically via the safe area.
        window.rootViewController = ProfileViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}
