# ScreenUtil

Responsive screen-adaptation library for Apple platforms. Scales UI from a fixed design size (e.g. 375×812 from Figma) to the real device. Inspired by `flutter_screenutil`. Pure Swift, zero dependencies. Builds on iOS / macOS / tvOS / watchOS.

This file orients code-review and cleanup work: it maps the code, marks the public contract that must not break, and records the rules that keep the package clean.

## Module Map

Organizing rule: **one platform = one place.** Everything outside `UIKit/` and `SwiftUI/` must be pure cross-platform (Foundation + CoreGraphics only). This makes the macOS build structurally safe and keeps dead code visible.

| Path | Role |
|------|------|
| `Core/ScreenUtil.swift` | Singleton engine (`ScreenUtil.shared`), `configure`, `scale`/`fastScale`, `.w/.h/.sp/.r/.sw/.sh/.fast*` |
| `Core/ScreenUtilConfiguration.swift` | Config struct + device presets (`iPhone13Pro`, `iPadPro11`, …) |
| `Core/ScaleType.swift` | Protocols (`ScreenScalable`, `ScreenUtilConfigurable`, `ScreenDimensionProvider`) + `ScaleType` |
| `Core/ScalingLimits.swift` | `ScalingLimits` (`.default`/`.strict`/`.relaxed`) |
| `Core/ScreenMetrics.swift` | `ScreenMetrics` snapshot |
| `Internal/Atomic.swift` | `Atomic`, `UnsafeAtomicDouble` — **internal**, lock-backed property wrappers |
| `Internal/ScaleFactorCache.swift` | Captured factors for batch/fast scaling + `cgFloatValue(_:)` Numeric→CGFloat bridge |
| `Internal/ScreenDimensionsCache.swift` | TTL cache + rotation invalidation for dimensions |
| `Internal/SafeAreaCacheManager.swift` | TTL cache + invalidation for safe-area insets |
| `Metrics/ScreenDimensions.swift` | Platform dimensions snapshot (UIKit-gated reader) |
| `Metrics/SafeAreaInsets.swift` | Platform safe-area snapshot (UIKit-gated reader) |
| `Metrics/DeviceType.swift` | Device/platform classification |
| `Scaling/Numeric+Scaling.swift` | `Int/Float/Double/CGFloat` `.w/.h/.sp/.r/.sw/.sh/.fast*` |
| `Scaling/CGGeometry+Scaling.swift` | `CGSize/CGPoint/CGRect` scaling (cross-platform) |
| `Scaling/FastScale.swift` | `FastScale` capture-once struct for hot loops + `withFastScale` |
| `Scaling/BatchScaling.swift` | `batch*` methods + `BatchScaler` for bulk scaling |
| `UIKit/UIFont+Scaling.swift` | `UIFont` scaled helpers (`#if canImport(UIKit)`) |
| `UIKit/UIView+Scaling.swift` | `UIView` constraint/styling + `NSLayoutConstraint.updateConstant` |
| `UIKit/UIEdgeInsets+Scaling.swift` | `UIEdgeInsets.scaled(...)` |
| `SwiftUI/View+Responsive.swift` | `View` modifiers, `Font.scaledSystem/scaledCustom`, `EnvironmentValues.screenUtil` |
| `SwiftUI/ScaledValue.swift` | `@ScaledValue`, `@ScreenPercentage` property wrappers |
| `Debug/ScreenUtilDebug.swift` | Debug logging, benchmarking, validation, overlay |

## Public Contract (must not break)

Anything not reachable from this set is a removal/merge candidate.

- `ScreenUtil.shared` + `configure(with:)` — singleton, configured once at launch.
- Numeric scaling: `.w .h .sp .r .sw .sh` and fast variants `.fastW .fastH .fastSp`.
- `ScreenUtilConfiguration` (+ presets) and `ScalingLimits`.
- `FastScale` / `withFastScale`, `BatchScaler` / `withBatchScaler` / `batch*`.
- SwiftUI: `responsiveFrame/responsivePadding/responsiveCornerRadius`, `Font.scaledSystem`, `@ScaledValue`, `@ScreenPercentage`.
- UIKit: `UIFont.systemFont(…, scaled:)`, `UIView` helpers, `UIEdgeInsets.scaled`.

## Review Checklist (when editing)

- Keep **zero dependencies** — `Package.swift` `dependencies: []` stays empty.
- **One platform = one place**: UIKit code only under `UIKit/` (or `#if canImport(UIKit)` blocks); SwiftUI only under `SwiftUI/`. Never bare `import UIKit` in cross-platform files — breaks macOS.
- Builds under `-strict-concurrency=complete` — no new concurrency warnings.
- `ScreenUtil` is `@unchecked Sendable`. New shared state must be `Sendable` / atomic.
- Bulk APIs accept `[T: Numeric]` — route through `cgFloatValue(_:)` so `CGFloat`/`Int64`/etc don't silently scale to zero.
- Removing code: confirm it's not reachable from the Public Contract and not referenced in `Tests/` or `Examples/`.
- Verify with `swift build` **and** `swift test` on macOS (catches the platform-isolation regressions).

## Known Issues (not yet addressed)

- **Data race**: `_scaleWidth/_scaleHeight/_scaleText` are plain `var` read without synchronization (only `@unchecked Sendable` hides it). TSan would flag. A proper fix needs atomic reads.
- **Stale on rotation**: caches invalidate on orientation change, but scale factors only recompute on `configure()`/`refreshMetrics()`. No observer re-derives `_scale*` after rotation.
- **`fastW` ≈ `.w`**: measured ~1.1× faster, not the README's "6×". For real hot loops use `FastScale` (capture-once).
- **README drift**: README documents APIs that don't exist (`.ssp`, `adaptiveFont`, `isIPad`, `pixelRatio`, `orientation`, `bottomSafeArea`, `prewarmCaches`, `ResponsiveGrid`, `fontResolver`, `debugMode`). Reconcile before publishing.

## Build & Test

```bash
swift build
swift test
```
