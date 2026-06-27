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
        // Navigation controller gives the inline "UIKit Demo" title, mirroring the
        // SwiftUI demo's NavigationStack("SwiftUI Demo").
        window.rootViewController = UINavigationController(rootViewController: ProfileViewController())
        self.window = window
        window.makeKeyAndVisible()
    }
}
