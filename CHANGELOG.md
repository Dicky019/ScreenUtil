# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

> Pre-1.0; the public API is still changing.

### Changed
- **Swift 6 language mode** (`swift-tools-version: 6.0`, `swiftLanguageModes: [.v6]`).
- **Concurrency model**: UIKit metric reads are isolated to `@MainActor`; scale
  factors are published as an immutable atomic snapshot. All scaling reads stay
  nonisolated (lock-free, race-free; verified under ThreadSanitizer).
- `configure(with:)` and `refreshMetrics()` are now `@MainActor`.
- Restructured `Sources` into a platform-isolated layout
  (Core / Internal / Metrics / Scaling / UIKit / SwiftUI / Debug).
- SwiftUI `responsiveCornerRadius` now uses `clipShape` (deprecated `.cornerRadius` removed).
- Replaced all `print` logging with unified logging (`os.Logger`, subsystem `com.screenutil`).
- Raised deployment baseline to iOS 15 / macOS 12 / tvOS 15 / watchOS 8.
- `ScreenDimensions.current` now derives from the active `UIWindowScene` instead of the soft-deprecated `UIScreen.main`.
- Public value types (`ScalingLimits`, `ScreenMetrics`, `ScreenDimensions`, `SafeAreaInsets`, `ScreenUtilConfiguration`, `ScaleType`, `DeviceType`) now conform to `Equatable`/`Hashable`.

### Fixed
- Scale-factor data race on concurrent reads during reconfigure.
- macOS build failure from unguarded `import UIKit`.
- Batch scaling returning zeros for `CGFloat` / `Int64` inputs.
- Scale factors now refresh on device rotation (orientation/scene notifications).

### Removed (breaking)
- `ScaleType` cases `.font`, `.min`, `.max`, `.auto` (now `.width`, `.height`, `.text`, `.radius`).
- `ScreenUtilConfiguration.deviceType` — use `ScreenUtil.shared.deviceType`.
- Dead SwiftUI modifiers/wrappers, duplicate types, and the buggy `Array<Numeric>` scaling extension.
- `ScreenUtilConfiguration.splitScreenMode` — unused, removed from the config and `ScreenUtilConfigurable`.
- `ScaledValue.ScaleType` nested enum — `@ScaledValue` now uses the top-level `ScaleType` (`.font` → `.text`, `.auto` removed; default is `.width`).
- Benchmark APIs (`measurePerformance`, `benchmarkScalingOperations`) are now `#if DEBUG`-only.

### Dependencies
- One dependency: [apple/swift-atomics](https://github.com/apple/swift-atomics), used for the lock-free scale-factor snapshot.

### Notes
- Pre-1.0: no version has been tagged yet, and the public API is still changing.
  The current state is the platform-isolated Swift 6 engine described above; the
  next tagged release will become `1.0.0`.