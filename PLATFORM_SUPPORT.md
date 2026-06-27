# ScreenUtil Platform Support

## Overview

ScreenUtil runs on all Apple platforms. UIKit is **not** required: where it's
available the library reads real screen metrics and safe areas and auto-refreshes
on scene/orientation changes; where it isn't (macOS/watchOS, command-line, SwiftUI
previews) it falls back to platform-appropriate defaults that you can override via
`configure(with:)`.

## Supported Platforms

| Platform | Minimum | Screen metrics source |
|----------|---------|-----------------------|
| iOS / iPadOS | **15.0** | Active `UIWindowScene` (UIKit) |
| macOS | **12.0** | Platform default (no UIKit) |
| tvOS | **15.0** | UIKit |
| watchOS | **8.0** | Platform default |

## Dependencies

```swift
// Required across all platforms:
import Foundation
import CoreGraphics
import Atomics      // apple/swift-atomics — the lock-free scale-factor snapshot

// Conditionally compiled, only where available:
#if canImport(UIKit)
import UIKit        // iOS, tvOS — screen detection, safe areas, change notifications
#endif

#if canImport(SwiftUI)
import SwiftUI      // EnvironmentValues.screenUtil
#endif
```

There is exactly one external dependency, [apple/swift-atomics](https://github.com/apple/swift-atomics).

## Fallback Strategy

1. **Screen detection**
   - **With UIKit**: derived from the active `UIWindowScene` (not the soft-deprecated `UIScreen.main`).
   - **Without UIKit**: platform default (see below).

2. **Safe-area detection**
   - **With UIKit**: native safe-area insets captured from the window at rebuild time.
   - **Without UIKit / before a window exists**: all insets are `0`.

3. **Change handling**
   - **With UIKit**: the snapshot rebuilds automatically on `UIScene.didActivate` and `UIDevice.orientationDidChange`.
   - **Without UIKit**: call `ScreenUtil.shared.refreshMetrics()` manually (e.g. after a macOS window resize).

## Platform Defaults

Used before configuration, and on platforms without UIKit. Safe-area insets and
status-bar height default to `0` until a real window provides them.

```swift
// iOS      — ScreenDimensions(width: 375,  height: 812,  scale: 3.0)
// macOS    — ScreenDimensions(width: 1440, height: 900,  scale: 2.0)
// tvOS     — ScreenDimensions(width: 1920, height: 1080, scale: 1.0)
// watchOS  — ScreenDimensions(width: 184,  height: 224,  scale: 2.0)
```

## Usage

### Core scaling — all platforms, no UIKit needed

```swift
let width  = 100.w   // width  scaling
let height = 50.h    // height scaling
let font   = 16.sp   // text   scaling (no distortion)
let radius = 12.r    // radius scaling

let halfWidth    = 50.sw   // 50% of screen width
let tenthHeight  = 10.sh   // 10% of screen height
```

`.w/.h/.sp/.r/.sw/.sh` are available on `Int`, `Float`, `Double`, and `CGFloat`,
and `CGSize/CGPoint/CGRect` have their own scaling helpers — all cross-platform.

### UIKit-only helpers

Wrap UIKit-specific code in `#if canImport(UIKit)` for cross-platform sources:

```swift
#if canImport(UIKit)
let font   = UIFont.systemFont(ofSize: 16, weight: .medium, scaled: true)
let insets = UIEdgeInsets.scaled(horizontal: 20, vertical: 10)
view.cornerRadius(12)
#endif
```

### Manual configuration for non-UIKit environments

```swift
// Set your design canvas explicitly (or use a preset like .iPhone12).
let config = ScreenUtilConfiguration(designSize: CGSize(width: 375, height: 812))
ScreenUtil.shared.configure(with: config)

// Refresh after a screen change UIKit can't observe for you (e.g. macOS resize).
ScreenUtil.shared.refreshMetrics()
```

## Best Practices

1. **Use the core scaling APIs** (`.w`, `.h`, `.sp`, `.r`) — they work everywhere.
2. **Wrap platform-specific code** in `#if canImport(UIKit)` / `#if canImport(SwiftUI)`.
3. **Configure once at launch** on the main actor; reads afterwards are lock-free.
4. **Test on all target platforms** (`swift build` + `swift test` on macOS catch the platform-isolation regressions).
