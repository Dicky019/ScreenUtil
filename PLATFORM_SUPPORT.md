# ScreenUtil Platform Support

## Overview

ScreenUtil is designed to work across all Apple platforms without requiring UIKit as a dependency. The library automatically adapts to the available frameworks and provides fallback implementations where needed.

## Platform Support

### ✅ **iOS 13.0+**
- **UIKit Available**: Full functionality with automatic screen detection, safe area handling, and orientation change notifications
- **UIKit Unavailable**: Fallback to sensible defaults with manual configuration support

### ✅ **macOS 10.15+**
- **AppKit/SwiftUI**: Core scaling functionality with platform-appropriate defaults
- **Default Screen**: 1440x900 @2x (MacBook Air equivalent)

### ✅ **tvOS 13.0+**
- **UIKit Available**: Full TV-optimized functionality
- **Default Screen**: 1920x1080 @1x with appropriate safe areas for TV bezels

### ✅ **watchOS 6.0+**
- **WatchKit**: Optimized for small screen scaling
- **Default Screen**: 184x224 @2x (Apple Watch Series 7 41mm equivalent)

## Architecture

### Core Dependencies
```swift
// Only these frameworks are required across all platforms:
import Foundation
import CoreGraphics
import QuartzCore // For CACurrentMediaTime
```

### Optional Dependencies
```swift
// These are conditionally imported only when available:
#if canImport(UIKit)
import UIKit  // iOS, tvOS - for screen detection and safe areas
#endif

#if canImport(SwiftUI)
import SwiftUI  // All platforms - for SwiftUI extensions
#endif

#if canImport(AppKit)
import AppKit  // macOS - for future AppKit-specific features
#endif
```

### Fallback Strategy

1. **Screen Detection**
   - **With UIKit**: Uses `UIScreen.main.bounds` and `UIDevice.current.userInterfaceIdiom`
   - **Without UIKit**: Uses platform-appropriate defaults

2. **Safe Area Detection**
   - **With UIKit**: Uses `UIApplication.shared.connectedScenes` and window safe areas
   - **Without UIKit**: Uses platform-specific safe area defaults

3. **Orientation Changes**
   - **With UIKit**: Automatically invalidates caches on `UIDevice.orientationDidChangeNotification`
   - **Without UIKit**: Manual cache invalidation via `refreshMetrics()`

## Platform Defaults

### iOS (without UIKit)
```swift
// Screen: iPhone 13 Pro equivalent
ScreenDimensions(width: 375, height: 812, scale: 3.0)
SafeAreaInsets(top: 44, bottom: 34, left: 0, right: 0, statusBarHeight: 44)
```

### macOS
```swift
// Screen: MacBook Air equivalent
ScreenDimensions(width: 1440, height: 900, scale: 2.0)
SafeAreaInsets(top: 0, bottom: 0, left: 0, right: 0, statusBarHeight: 24)
```

### tvOS (without UIKit)
```swift
// Screen: Apple TV 4K
ScreenDimensions(width: 1920, height: 1080, scale: 1.0)
SafeAreaInsets(top: 60, bottom: 60, left: 90, right: 90, statusBarHeight: 0)
```

### watchOS
```swift
// Screen: Apple Watch Series 7 41mm
ScreenDimensions(width: 184, height: 224, scale: 2.0)
SafeAreaInsets(top: 0, bottom: 0, left: 0, right: 0, statusBarHeight: 0)
```

## Usage Examples

### Core Scaling (All Platforms)
```swift
// These work on all platforms without any dependencies
let scaledWidth = 100.w
let scaledHeight = 50.h
let scaledFont = 16.sp
let scaledRadius = 12.r

// Screen percentages
let halfScreen = 50.sw
let quarterScreen = 25.sh
```

### Platform-Independent Types
```swift
// ResponsiveInsets works on all platforms
let insets = ResponsiveInsets.responsive(
    top: 16, leading: 20, bottom: 16, trailing: 20
)

// Convert to platform-specific types when available
#if canImport(UIKit)
let uiInsets = insets.uiEdgeInsets
#endif

#if canImport(SwiftUI)
let swiftUIInsets = insets.edgeInsets
#endif
```

### Font Scaling
```swift
// Platform-independent font descriptor
let fontDesc = ResponsiveFontDescriptor(size: 16, weight: .medium)

#if canImport(UIKit)
let uiFont = fontDesc.uiFont
#endif

#if canImport(SwiftUI)
let swiftUIFont = fontDesc.swiftUIFont
#endif
```

### Manual Configuration for Non-UIKit Environments
```swift
// Explicitly set screen dimensions if UIKit detection isn't available
let config = ScreenUtilConfiguration(
    designSize: CGSize(width: 375, height: 812)
)
ScreenUtil.shared.configure(with: config)

// Manually refresh metrics when screen changes (e.g., window resize on macOS)
ScreenUtil.shared.refreshMetrics()
```

## Best Practices

1. **Always use the core scaling APIs** (`.w`, `.h`, `.sp`, `.r`) - they work everywhere
2. **Use platform-independent types** (`ResponsiveInsets`, `ResponsiveFontDescriptor`) for cross-platform code
3. **Wrap platform-specific code** in `#if canImport()` blocks
4. **Test on all target platforms** to ensure fallbacks work correctly
5. **Consider manual configuration** for specialized environments

## Migration from UIKit-dependent Code

### Before (UIKit Required)
```swift
let insets = UIEdgeInsets(top: 16.h, left: 20.w, bottom: 16.h, right: 20.w)
let font = UIFont.systemFont(ofSize: 16.sp, weight: .medium)
```

### After (Platform Independent)
```swift
let insets = ResponsiveInsets.responsive(top: 16, leading: 20, bottom: 16, trailing: 20)
let fontDesc = ResponsiveFontDescriptor(size: 16, weight: .medium)

// Convert to platform types when needed
#if canImport(UIKit)
let uiInsets = insets.uiEdgeInsets
let uiFont = fontDesc.uiFont
#endif
```

## Performance Impact

The optional UIKit approach has minimal performance impact:

- **Compile-time**: Conditional compilation eliminates unused code
- **Runtime**: No performance difference when UIKit is available
- **Fallback mode**: Slightly faster due to no framework overhead
- **Memory**: Reduced memory usage when UIKit isn't needed

This architecture ensures ScreenUtil can be used in:
- iOS apps (with or without UIKit)
- macOS apps (AppKit, SwiftUI, or Catalyst)
- tvOS apps
- watchOS apps
- Command-line tools
- Server-side Swift
- Cross-platform frameworks