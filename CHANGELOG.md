# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project setup and structure

### Changed
- Clarified `.auto` scale type now defaults to width-based scaling

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