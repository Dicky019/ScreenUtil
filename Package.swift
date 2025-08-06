// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "ScreenUtil",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "ScreenUtil",
            targets: ["ScreenUtil"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ScreenUtil",
            dependencies: [],
            path: "Sources/ScreenUtil",
            exclude: ["Info.plist"],
            resources: [
                .copy("PrivacyInfo.xcprivacy")
            ],
            swiftSettings: [
                .define("SPM_BUILD"),
                .unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"]),
            ]
        ),
        .testTarget(
            name: "ScreenUtilTests",
            dependencies: ["ScreenUtil"],
            path: "Tests/ScreenUtilTests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
