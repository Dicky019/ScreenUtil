# ScreenUtil Examples

This directory contains comprehensive examples demonstrating how to use ScreenUtil in both UIKit and SwiftUI applications.

## Quick Start

For a lightweight demonstration of identical interfaces in both frameworks, see the one-page examples:

- **SimpleUIKit** – UIKit implementation.
- **SimpleSwiftUI** – SwiftUI implementation.

Both present the same counter interface to highlight consistent layouts with ScreenUtil.

## Files

### UIKitExample.swift
Complete UIKit implementation examples including:

#### Basic Usage
- **BasicUIKitViewController**: Demonstrates fundamental ScreenUtil usage
  - Responsive layout with `.w`, `.h`, `.sp`, `.r` extensions
  - Auto Layout with scaled constraints
  - Screen metrics access and display
  - Configuration setup

#### Advanced Features
- **AdvancedUIKitViewController**: Shows advanced capabilities
  - Batch operations for scaling multiple values
  - Fast scaling with `FastScale` struct
  - Custom scaling limits demonstration
  - Performance benchmarking
  - ScrollView with multiple sections

#### Custom Components
- **ResponsiveCardView**: Custom UIView with built-in responsive design
  - Responsive images, labels, and buttons
  - Auto Layout with ScreenUtil scaling
  - Shadow and corner radius scaling

### SwiftUIExample.swift
Complete SwiftUI implementation examples including:

#### Basic SwiftUI Views
- **BasicSwiftUIView**: Core SwiftUI usage patterns
  - `.scaledSystem()` font modifier
  - `.responsivePadding()` and `.responsiveCornerRadius()` modifiers
  - Grid layouts with responsive spacing
  - Screen metrics display

#### Advanced SwiftUI Features
- **PropertyWrappersDemo**: Property wrapper usage
  - `@ScaledValue` for automatic value scaling
  - `@ScreenPercentage` for percentage-based sizing
  - `@ResponsiveFont` for adaptive typography

- **ViewModifiersDemo**: Custom view modifiers
  - `.responsiveFrame()` modifier
  - `.responsivePadding()` modifier
  - Animated scaling examples

#### Custom Components
- **ResponsiveProfileCard**: Professional profile card
- **ResponsiveProgressBar**: Animated progress indicator
- **ResponsiveStatsView**: Statistics grid layout
- **PerformanceDemoView**: Real-time performance testing

## Key Features Demonstrated

### 1. Basic Scaling
```swift
// UIKit
button.widthAnchor.constraint(equalToConstant: 100.w)
label.font = .systemFont(ofSize: 16.sp)
view.layer.cornerRadius = 8.r

// SwiftUI
Text("Hello").font(.scaledSystem(size: 16))
Rectangle().frame(width: 100.w, height: 50.h)
```

### 2. Configuration
```swift
// Set design size (e.g., iPhone 13 Pro)
ScreenUtil.shared.configure(with: .iPhone13Pro)

// Custom configuration
let config = ScreenUtilConfiguration(
    designSize: CGSize(width: 390, height: 844),
    minTextAdapt: true,
    scalingLimits: .default
)
ScreenUtil.shared.configure(with: config)
```

### 3. Batch Operations
```swift
let values = [10, 20, 30, 40, 50]
let scaledWidths = ScreenUtil.shared.batchWidths(values)
let scaledHeights = ScreenUtil.shared.batchHeights(values)
```

### 4. Fast Scaling
```swift
let fastScale = ScreenUtil.shared.fastScale
let scaledSize = fastScale.size(CGSize(width: 100, height: 50))
let scaledPoint = fastScale.point(CGPoint(x: 10, y: 20))
```

### 5. Screen Metrics
```swift
let metrics = ScreenUtil.shared.getScreenMetrics()
print("Screen: \(metrics.width) x \(metrics.height)")
print("Safe Area Top: \(metrics.safeAreaInsets.top)")
print("Device: \(ScreenUtil.shared.deviceType)")
```

### 6. Debug Tools
```swift
// Print current configuration
ScreenUtil.shared.debug.printCurrentConfiguration()

// Run performance benchmark
ScreenUtil.shared.debug.benchmarkScalingOperations()

// Generate test report
let report = ScreenUtil.shared.debug.generateTestReport()
```

## Usage Instructions

### For UIKit Projects
1. Import ScreenUtil in your view controllers
2. Configure ScreenUtil in your app launch or viewDidLoad
3. Use the scaling extensions (.w, .h, .sp, .r) throughout your UI code
4. Copy and adapt the example view controllers as needed

### For SwiftUI Projects
1. Import ScreenUtil in your SwiftUI views
2. Configure ScreenUtil in your app startup or view onAppear
3. Use the font and view modifiers for responsive design
4. Leverage property wrappers for automatic scaling
5. Copy and adapt the example views as needed

## Performance Notes

- Fast scaling operations are ~1.4x faster than standard scaling
- Batch operations are optimized for processing multiple values
- All operations are thread-safe and can be used from any queue
- Memory usage is minimal with efficient caching strategies

## Best Practices

1. **Configure Early**: Set up ScreenUtil configuration as early as possible in your app lifecycle
2. **Use Appropriate Scale Types**: Choose .w for widths, .h for heights, .sp for text, .r for radii
3. **Leverage Batch Operations**: Use batch scaling when processing multiple values
4. **Test on Multiple Devices**: Verify your responsive design on different screen sizes
5. **Monitor Performance**: Use the built-in debugging tools to optimize performance