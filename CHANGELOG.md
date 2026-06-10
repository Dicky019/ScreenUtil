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
- Added [apple/swift-atomics](https://github.com/apple/swift-atomics) for the lock-free snapshot.

## [1.0.0] - 2025-01-XX

### Added
- **Core ScreenUtil class** with singleton pattern for responsive screen adaptation
- **Screen dimension properties**: `screenWidth`, `screenHeight`, `scaleWidth`, `scaleHeight`, `scaleText`
- **Safe area support**: `topSafeArea`, `bottomSafeArea`, `statusBarHeight`
- **Device information**: `pixelRatio` for device pixel density
- **Configuration methods**:
  - `setDesignSize(width:height:)` - Set reference design dimensions
  - `setMinTextAdapt(_:)` - Enable/disable minimum text adaptation
  - `setSplitScreenMode(_:)` - Enable/disable split screen support
  - `setFontResolver(_:)` - Custom font scaling resolver
  - `refresh()` - Manual screen dimension refresh
- **CGFloat extensions** for easy scaling:
  - `.scaleWidth` - Scale by width factor
  - `.scaleHeight` - Scale by height factor  
  - `.scaleText` - Scale for text (minimum factor)
  - `.scale(by:)` - Scale by custom factor
- **SwiftUI support** with view modifiers and extensions
- **Orientation handling** with automatic updates
- **iOS 12.0+ and tvOS 12.0+ support**
- **Swift 6.1+ compatibility**
- **Comprehensive unit tests** for all core functionality
- **Apache 2.0 license** for open source distribution
- **Complete documentation** with README and API reference

### Technical Details
- **Platform Support**: iOS 12.0+, tvOS 12.0+
- **Swift Version**: 6.1+
- **Xcode Version**: 15.0+
- **Architecture**: Singleton pattern with thread-safe implementation
- **Performance**: Optimized for minimal overhead and efficient scaling calculations

### Documentation
- Complete README.md with installation and usage examples
- API reference with all public methods and properties
- Code examples for both UIKit and SwiftUI integration
- Contributing guidelines and license information

---

## Version History

- **1.0.0** - Initial release with core responsive design functionality 