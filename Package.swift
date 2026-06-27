// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ScreenUtil",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "ScreenUtil",
            targets: ["ScreenUtil"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-atomics.git", exact: "1.3.0")
    ],
    targets: [
        .target(
            name: "ScreenUtil",
            dependencies: [
                .product(name: "Atomics", package: "swift-atomics")
            ],
            path: "Sources/ScreenUtil",
            resources: [
                .copy("PrivacyInfo.xcprivacy")
            ],
            swiftSettings: [
                .define("SPM_BUILD")
            ]
        ),
        .testTarget(
            name: "ScreenUtilTests",
            dependencies: ["ScreenUtil"],
            path: "Tests/ScreenUtilTests"
        ),
    ],
    swiftLanguageModes: [.v6]
)
