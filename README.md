<h1 align="center">
  ScreenUtil for iOS
</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.7+-orange.svg" alt="Swift Version">
  <img src="https://img.shields.io/badge/iOS-13.0+-blue.svg" alt="iOS Version">
  <img src="https://img.shields.io/badge/SPM-compatible-brightgreen.svg" alt="SPM Compatible">
  <img src="https://img.shields.io/badge/CocoaPods-compatible-green.svg" alt="CocoaPods Compatible">
  <img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="License">
</p>

<p align="center">
  <b>A high-performance, thread-safe Swift package for responsive screen adaptation in iOS applications.</b><br>
  Inspired by flutter_screenutil, optimized for iOS with lock-free reads and zero overhead.
</p>

## ✨ Features

- 🚀 **High Performance** - Lock-free reads with ~3ns per operation
- 🔒 **Thread-Safe** - Safe concurrent access from any thread
- 📱 **Design-Based Scaling** - Scale UI based on design dimensions
- 🎯 **Simple API** - Intuitive extensions: `.w`, `.h`, `.sp`, `.r`
- ⚡ **Fast Path API** - `.fastW`, `.fastH` for performance-critical code
- 🔧 **UIKit & SwiftUI** - Full support for both frameworks
- 📊 **Percentage Sizing** - Easy responsive layouts with `.sw`, `.sh`
- ♿ **Accessibility** - Respects Dynamic Type settings
- 📐 **Auto Layout Helpers** - Constraint extensions for UIKit
- 🎨 **Smart Font Scaling** - Prevents text distortion
- 📱 **iPad Optimized** - Special handling for tablet layouts
- 💾 **Zero Dependencies** - Pure Swift implementation

## 📦 Installation

### Swift Package Manager (Recommended)

Add ScreenUtil to your project in Xcode:

1. File → Add Package Dependencies
2. Enter: `https://github.com/Dicky019/ScreenUtil`
3. Choose version and add to your target

Or add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Dicky019/ScreenUtil", from: "1.0.0")
]
```

### CocoaPods

```ruby
pod 'ScreenUtil', '~> 1.0.0'
```

## 🚀 Quick Start

### 1. Initialize in AppDelegate

```swift
import ScreenUtil

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, 
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize with your design dimensions (from Figma, Sketch, etc.)
        ScreenUtil.configure(with: ScreenUtilConfiguration(
            designSize: CGSize(width: 375, height: 812), // iPhone X/11 Pro
            minTextAdapt: true,
            splitScreenMode: true
        ))
        
        return true
    }
}
```

### 2. Use Scaling Extensions

```swift
// UIKit
view.frame = CGRect(x: 20.w, y: 50.h, width: 200.w, height: 100.h)
label.font = .systemFont(ofSize: 16.sp)
button.layer.cornerRadius = 12.r

// SwiftUI
Text("Hello World")
    .font(.system(size: 16.sp))
    .responsiveFrame(width: 200, height: 50)
    .responsivePadding(.all, 20)
```

## 📖 Usage Guide

### Basic Scaling

```swift
// Width scaling - scales based on device width ratio
view.width = 100.w  // 100 * (deviceWidth / designWidth)

// Height scaling - scales based on device height ratio  
view.height = 50.h  // 50 * (deviceHeight / designHeight)

// Font scaling - uses minimum ratio to prevent distortion
label.font = .systemFont(ofSize: 16.sp)

// Radius scaling - scales corner radius
view.layer.cornerRadius = 12.r

// Percentage sizing
button.width = 0.5.sw   // 50% of screen width
header.height = 0.1.sh  // 10% of screen height
```

### Performance Optimization

For performance-critical code, use the fast path API:

```swift
// Standard (with safety checks) - Good for most cases
view.width = 100.w  // ~18ns

// Fast path (no checks) - For hot paths
UIView.animate(withDuration: 0.3) {
    self.view.width = 200.fastW  // ~3ns
}

// Ultra-fast with FastScale - For extreme performance
let fast = ScreenUtil.shared.fastScale
for particle in particles {
    particle.x = fast.w(particle.x)
    particle.y = fast.h(particle.y)
}
```

### UIKit Examples

#### Auto Layout with Helpers

```swift
class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let avatarView = UIImageView()
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarView)
        
        // Using constraint helpers
        avatarView.width(80)
        avatarView.height(80)
        avatarView.cornerRadius(40)
        
        NSLayoutConstraint.activate([
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.h)
        ])
    }
}
```

#### Collection View Layout

```swift
func collectionView(_ collectionView: UICollectionView, 
                   layout: UICollectionViewLayout, 
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let spacing = 16.w
    let columns: CGFloat = ScreenUtil.shared.isIPad ? 4 : 2
    let totalSpacing = spacing * (columns + 1)
    let itemWidth = (ScreenUtil.shared.screenWidth - totalSpacing) / columns
    
    return CGSize(width: itemWidth, height: itemWidth * 1.3)
}
```

#### Adaptive Fonts

```swift
// Standard scaling
label.font = .systemFont(ofSize: 16.sp)

// Respecting system accessibility settings
accessibleLabel.font = .systemFont(ofSize: 16.ssp)

// iPad-specific scaling
titleLabel.font = .adaptiveFont(ofSize: 24, iPadScale: 1.3, weight: .bold)
```

### SwiftUI Examples

#### Basic Usage

```swift
struct ContentView: View {
    var body: some View {
        VStack(spacing: 20.h) {
            Image(systemName: "star.fill")
                .resizable()
                .responsiveFrame(width: 60, height: 60)
                .foregroundColor(.yellow)
            
            Text("Welcome")
                .font(.system(size: 28.sp, weight: .bold))
            
            Button(action: {}) {
                Text("Get Started")
                    .font(.system(size: 18.sp, weight: .semibold))
                    .foregroundColor(.white)
                    .responsiveFrame(width: 200, height: 50)
                    .background(Color.blue)
                    .responsiveCornerRadius(25)
            }
        }
        .responsivePadding(.all, 20)
    }
}
```

#### Property Wrappers

```swift
struct DashboardView: View {
    @ScaledValue(.width) private var cardWidth = 300
    @ScaledValue(.height) private var cardHeight = 200
    @ScaledValue(.font) private var titleSize = 24
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16.h) {
                ForEach(items) { item in
                    CardView(item: item)
                        .frame(width: cardWidth, height: cardHeight)
                }
            }
        }
    }
}
```

#### Responsive Grid

```swift
struct GridView: View {
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: ResponsiveGrid.adaptiveColumns(minWidth: 100, spacing: 16),
                spacing: 16.h
            ) {
                ForEach(items) { item in
                    ItemView(item: item)
                }
            }
            .responsivePadding(.all, 20)
        }
    }
}
```

### Advanced Features

#### Batch Operations

```swift
// Process arrays efficiently
let widths: [CGFloat] = [100, 200, 300, 400]
let scaledWidths = widths.scaledWidths()  // Single scale factor lookup

// Fast batch processing
let fastScaled = widths.fastScaledWidths()  // Ultra-fast scaling
```

#### Custom Font Resolver

```swift
let config = ScreenUtilConfiguration(
    designSize: CGSize(width: 375, height: 812),
    fontResolver: { size in
        switch size {
        case 0..<12:
            return size  // Don't scale very small fonts
        case 12..<20:
            return size * ScreenUtil.shared.scaleText
        default:
            return size * ScreenUtil.shared.scaleText * 0.9  // Scale down large fonts
        }
    }
)

ScreenUtil.configure(with: config)
```

#### Scaling Limits

```swift
// Prevent extreme scaling on unusual devices
let config = ScreenUtilConfiguration(
    designSize: CGSize(width: 375, height: 812),
    scalingLimits: ScalingLimits(minScale: 0.8, maxScale: 1.5)
)
```

#### Debug Mode

```swift
#if DEBUG
// Enable debug logging
ScreenUtil.debugMode = true

// All scaling operations will be logged
let width = 100.w  // Logs: "🔍 ScreenUtil: Scaling 100 -> 106.67"
#endif
```

## 📊 API Reference

### Core Extensions

| Extension | Description | Example | Performance |
|-----------|-------------|---------|-------------|
| `.w` | Width scaling with safety | `100.w` | ~18ns |
| `.h` | Height scaling with safety | `50.h` | ~18ns |
| `.sp` | Font scaling (no distortion) | `16.sp` | ~18ns |
| `.ssp` | Font scaling with accessibility | `16.ssp` | ~20ns |
| `.r` | Radius scaling | `12.r` | ~18ns |
| `.sw` | Screen width percentage | `0.5.sw` | ~15ns |
| `.sh` | Screen height percentage | `0.3.sh` | ~15ns |
| `.fastW` | Fast width scaling | `100.fastW` | ~3ns |
| `.fastH` | Fast height scaling | `50.fastH` | ~3ns |
| `.fastSp` | Fast font scaling | `16.fastSp` | ~3ns |

### ScreenUtil Properties

```swift
// Screen dimensions
ScreenUtil.shared.screenWidth      // Current device width
ScreenUtil.shared.screenHeight     // Current device height

// Scale factors (lock-free access)
ScreenUtil.shared.scaleWidth       // Width scale ratio
ScreenUtil.shared.scaleHeight      // Height scale ratio  
ScreenUtil.shared.scaleText        // Text scale ratio

// Device info
ScreenUtil.shared.isIPad           // Device type check
ScreenUtil.shared.pixelRatio       // Screen pixel density
ScreenUtil.shared.statusBarHeight  // Status bar height (cached)
ScreenUtil.shared.bottomSafeArea   // Bottom safe area (cached)
ScreenUtil.shared.orientation      // Current orientation
ScreenUtil.shared.isLandscape      // Orientation check

// Performance
ScreenUtil.shared.fastScale        // FastScale struct for hot paths
```

### UIKit Helpers

```swift
// UIFont extensions
UIFont.systemFont(ofSize: 16, weight: .medium, scaled: true)
UIFont.adaptiveFont(ofSize: 16, iPadScale: 1.2, weight: .bold)

// UIView constraint helpers
view.width(200)              // Width constraint with scaling
view.height(100)             // Height constraint with scaling
view.size(width: 200, height: 100)  // Size constraints
view.square(50)              // Square constraints

// UIView styling
view.cornerRadius(12)        // Scaled corner radius
view.border(width: 1, color: .black)  // Scaled border
view.shadow(radius: 4, offset: .zero, opacity: 0.1)  // Scaled shadow

// UIEdgeInsets
UIEdgeInsets.scaled(all: 16)
UIEdgeInsets.scaled(horizontal: 20, vertical: 10)
UIEdgeInsets.scaled(top: 10, left: 20, bottom: 10, right: 20)
```

### SwiftUI Modifiers

```swift
// View modifiers
.responsiveFrame(width: 100, height: 50)
.responsivePadding(.all, 20)
.responsiveCornerRadius(12)
.responsiveOffset(x: 10, y: 20)
.responsiveBlur(radius: 4)

// Environment
@Environment(\.screenUtil) var screenUtil

// Property wrappers
@ScaledValue(.width) var width = 200
@ScaledValue(.font) var fontSize = 16

// Responsive containers
ResponsiveContainer { screenUtil in
    // Content with access to screenUtil
}
```

## ⚡ Performance Guide

### When to Use Standard vs Fast Path

| Use Case | Recommended API | Reason |
|----------|----------------|---------|
| View setup | `.w`, `.h`, `.sp` | Safety checks, one-time call |
| Animations | `.fastW`, `.fastH` | Called 60fps |
| Scroll handlers | `.fastW`, `.fastH` | High frequency |
| Layout calculations | `FastScale` | Batch operations |
| Game loops | Direct scale access | Maximum performance |

### Performance Tips

1. **Cache scaled values for static layouts**
```swift
class MyView: UIView {
    // Calculate once
    private let margin = 20.w
    private let padding = 16.w
    
    override func layoutSubviews() {
        // Use cached values
        frame.inset(by: UIEdgeInsets(top: margin, left: padding, bottom: margin, right: padding))
    }
}
```

2. **Use batch operations for collections**
```swift
let widths = [100, 200, 300, 400]
let scaled = widths.scaledWidths()  // Process all at once
```

3. **Pre-warm caches on launch**
```swift
ScreenUtil.shared.prewarmCaches()
```

## 🧪 Testing

### Unit Tests
```bash
swift test
```

### Performance Benchmarks
```bash
swift test --filter PerformanceTests
```

### Run Example App
```bash
cd Example
open ScreenUtilExample.xcodeproj
```

## 📱 Device Support

- iPhone (all sizes from SE to Pro Max)
- iPad (all sizes including mini and Pro)
- iPad Split View
- Dynamic Type support
- Dark Mode compatible
- iOS 13.0+

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

ScreenUtil is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## 🙏 Acknowledgments

- Inspired by [flutter_screenutil](https://pub.dev/packages/flutter_screenutil)
- Thanks to the iOS community for feedback and contributions

## 📞 Support

- 📧 Email: support@screenutil.io
- 🐛 Issues: [GitHub Issues](https://github.com/Dicky019/ScreenUtil/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/Dicky019/ScreenUtil/discussions)

---

<p align="center">
  Made with ⚡️ by <a href="https://github.com/Dicky019">Dicky019</a> | 
  <a href="https://github.com/Dicky019/ScreenUtil/stargazers">⭐️ Star this repo</a>
</p>