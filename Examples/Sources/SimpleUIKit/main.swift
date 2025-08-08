//
//  SimpleUIKit.swift
//  ScreenUtil Examples
//
//  A minimal UIKit example demonstrating identical UI to the SwiftUI version.
//
import UIKit
import ScreenUtil

class SimpleUIKitViewController: UIViewController {
  private let label = UILabel()
  private let button = UIButton(type: .system)
  private var count = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    ScreenUtil.shared.configure(with: .iPhone13Pro)
    setupViews()
  }

  private func setupViews() {
    label.font = .systemFont(ofSize: 24.sp, weight: .bold)
    label.text = "Count: 0"
    label.textAlignment = .center

    button.setTitle("Increment", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16.sp, weight: .medium)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8.r
    button.addTarget(self, action: #selector(increment), for: .touchUpInside)

    [label, button].forEach {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100.h),
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24.h),
      button.widthAnchor.constraint(equalToConstant: 120.w),
      button.heightAnchor.constraint(equalToConstant: 44.h)
    ])
  }

  @objc private func increment() {
    count += 1
    label.text = "Count: \(count)"
  }
}

@main
class SimpleUIKitApp: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = SimpleUIKitViewController()
    window?.makeKeyAndVisible()
    return true
  }
}
