<h1 align="center">
  ScreenUtil
</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.7+-orange.svg" alt="Swift Version">
  <img src="https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20tvOS%20|%20watchOS-blue.svg" alt="Platforms">
  <img src="https://img.shields.io/badge/SPM-compatible-brightgreen.svg" alt="SPM Compatible">
  <img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="License">
</p>

<p align="center">
  <b>A thread-safe Swift package for responsive screen adaptation on Apple platforms.</b><br>
  Scale your UI from a fixed design size (e.g. 375×812 from Figma) to the real device. Inspired by flutter_screenutil.
</p>

## ✨ Features

- 🔒 **Thread-Safe** — lock-free reads via an atomic scale-factor snapshot (no torn reads)
- 📱 **Design-Based Scaling** — scale UI relative to your design dimensions
- 🎯 **Simple API** — intuitive extensions: `.w`, `.h`, `.sp`, `.r`
- ⚡ **Fast Path** — capture-once `FastScale` for hot loops
- 📦 **Batch Scaling** — `BatchScaler` / `withBatchScaler` for bulk work
- 🔧 **UIKit & SwiftUI** — first-class support for both
- 📊 **Percentage Sizing** — `.sw` / `.sh` for screen-relative layouts
- 🖥️ **Multi-platform** — iOS, macOS, tvOS, watchOS

> **Dependencies:** one — [apple/swift-atomics](https://github.com/apple/swift-atomics), used for the lock-free scale-factor snapshot.

## 📦 Installation

### Swift Package Manager

In Xcode: **File → Add Package Dependencies…** and enter:

```
https://github.com/Dicky019/ScreenUtil
```

Or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Dicky019/ScreenUtil", from: "1.0.0")
]
```

## 🚀 Quick Start

### 1. Configure once at launch

```swift
import ScreenUtil

// e.g. in AppDelegate / App init
ScreenUtil.shared.configure(with: ScreenUtilConfiguration(
    designSize: CGSize(width: 375, height: 812), // your design canvas
    minTextAdapt: true
))

// Or use a device preset:
ScreenUtil.shared.configure(with: .iPhone13Pro)
```

### 2. Scale values

```swift
// UIKit
view.frame = CGRect(x: 20.w, y: 50.h, width: 200.w, height: 100.h)
label.font = .systemFont(ofSize: 16.sp)
button.layer.cornerRadius = 12.r

// SwiftUI
Text("Hello World")
    .font(.system(size: 16.sp))
    .frame(width: 200.w, height: 50.h)
    .padding(.horizontal, 20.w).padding(.vertical, 20.h)
```

## 📖 Usage

### Basic scaling

```swift
100.w   // width  = 100 * (deviceWidth  / designWidth)
50.h    // height = 50  * (deviceHeight / designHeight)
16.sp   // font   = min(widthScale, heightScale) ratio (prevents distortion)
12.r    // radius = min(widthScale, heightScale) ratio

50.sw   // 50% of screen width
10.sh   // 10% of screen height
```

`.w`, `.h`, `.sp`, `.r`, `.sw`, `.sh` are available on `Int`, `Float`, `Double`, and `CGFloat`.

### Fast path for hot loops

`.w` validates its input (NaN/inf → 0). For tight per-frame loops, capture the factors once with `FastScale`:

```swift
withFastScale { fast in
    for particle in particles {
        particle.x = fast.width(particle.x)
        particle.y = fast.height(particle.y)
    }
}

// Or grab it directly:
let fast = ScreenUtil.shared.fastScale
view.frame = fast.rect(designRect)
```

### Batch scaling

```swift
let widths: [CGFloat] = [100, 200, 300, 400]
let scaled = ScreenUtil.shared.batchScaler.widths(widths)   // one factor lookup for all

// Reusable scaler:
let scaler = ScreenUtil.shared.batchScaler
let heights = scaler.heights([10, 20, 30])
let fonts   = scaler.fontSizes([12, 14, 16])
```

`BatchScaler` accepts any `[T: Numeric]` (`Int`, `Double`, `CGFloat`, `Int64`, …).

### Scaling limits

```swift
let config = ScreenUtilConfiguration(
    designSize: CGSize(width: 375, height: 812),
    scalingLimits: ScalingLimits(minScale: 0.8, maxScale: 1.5)
)
// Presets: .default, .strict, .relaxed
```

## 📱 UIKit

```swift
// Fonts
label.font = .systemFont(ofSize: 16, weight: .medium, scaled: true)
let custom = UIFont.customFont(name: "Helvetica", size: 14)        // UIFont? (scaled)
let scaled = existingFont.scaled()

// Auto Layout helpers (return the created constraint(s))
view.width(200)
view.height(100)
view.size(width: 200, height: 100)
view.cornerRadius(12)
view.borderWidth(1)

// Update a constraint with scaling (axis inferred from its attribute)
widthConstraint.updateConstant(120)

// Insets
let insets = UIEdgeInsets.scaled(all: 16)
let sym    = UIEdgeInsets.scaled(horizontal: 20, vertical: 10)
```

### Collection view example

```swift
func collectionView(_ collectionView: UICollectionView,
                    layout: UICollectionViewLayout,
                    sizeForItemAt indexPath: IndexPath) -> CGSize {
    let spacing = 16.w
    let columns: CGFloat = ScreenUtil.shared.deviceType == .iPad ? 4 : 2
    let totalSpacing = spacing * (columns + 1)
    let itemWidth = (ScreenUtil.shared.screenWidth - totalSpacing) / columns
    return CGSize(width: itemWidth, height: itemWidth * 1.3)
}
```

## 🎨 SwiftUI

### Scaling inside native modifiers

Apply the `.w/.h/.sp/.r` properties directly inside SwiftUI's own modifiers — no wrappers needed:

```swift
Image(systemName: "star.fill")
    .frame(width: 60.w, height: 60.h)

VStack {
    Text("Welcome").font(.system(size: 28.sp, weight: .bold))
}
.padding(.horizontal, 20.w).padding(.vertical, 20.h)
.clipShape(RoundedRectangle(cornerRadius: 16.r, style: .continuous))
```

### Fonts

Apply `.sp` to the size inside the native font APIs:

```swift
Text("Title").font(.system(size: 24.sp, weight: .bold))
Text("Body").font(.custom("Helvetica", size: 16.sp))
```

### Scaling values

Keep design values as plain constants and scale them at the call site with `.w/.h/.sp/.sw`:

```swift
struct CardView: View {
    private let cardWidth: CGFloat = 300
    private let cardHeight: CGFloat = 200
    private let titleSize: CGFloat = 24

    var body: some View {
        VStack { Text("Card").font(.system(size: titleSize.sp)) }
            .frame(width: cardWidth.w, height: cardHeight.h)
    }
}
```

### Environment

```swift
@Environment(\.screenUtil) private var screenUtil
```

## 📊 API Reference

### Numeric extensions

| Extension | Description | Example |
|-----------|-------------|---------|
| `.w` | Width scaling (validated) | `100.w` |
| `.h` | Height scaling (validated) | `50.h` |
| `.sp` | Font scaling (no distortion) | `16.sp` |
| `.r` | Radius scaling | `12.r` |
| `.sw` | Screen width percentage | `50.sw` |
| `.sh` | Screen height percentage | `10.sh` |

### `ScreenUtil.shared`

```swift
// Configuration
func configure(with: ScreenUtilConfiguration)
func refreshMetrics()
func getScreenMetrics() -> ScreenMetrics

// Scaling
func scale(for: CGFloat, scaleType: ScaleType) -> CGFloat
func fastScale(for: CGFloat, scaleType: ScaleType) -> CGFloat

// Dimensions & factors (lock-free reads)
var screenWidth / screenHeight: CGFloat
var safeAreaTop / safeAreaBottom / safeAreaLeft / safeAreaRight: CGFloat
var statusBarHeight: CGFloat
var scaleWidth / scaleHeight / scaleText: CGFloat
var deviceType: DeviceType          // .iPhone / .iPad / .mac / .tv / .watch

// Performance
var fastScale: FastScale
var batchScaler: BatchScaler
```

## 🐛 Debugging

```swift
ScreenUtilDebug.printCurrentConfiguration()

#if DEBUG
ScreenUtilDebug.benchmarkScalingOperations()  // DEBUG builds only
ScreenUtilDebug.showDebugOverlay(on: view)    // UIKit
#endif
```

## 🧪 Testing

```bash
swift build
swift test
swift test --sanitize=thread   # data-race check
```

## 📱 Device Support

iPhone, iPad (incl. Split View), plus macOS / tvOS / watchOS builds. iOS 15.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+.

## 🤝 Contributing

See the [Contributing Guide](CONTRIBUTING.md). Fork → branch → PR.

## 📄 License

ScreenUtil is available under the MIT license. See [LICENSE](LICENSE).

## 🙏 Acknowledgments

- Inspired by [flutter_screenutil](https://pub.dev/packages/flutter_screenutil)
- Lock-free reads built on [apple/swift-atomics](https://github.com/apple/swift-atomics)

---

<p align="center">
  Made by <a href="https://github.com/Dicky019">Dicky019</a>
</p>
