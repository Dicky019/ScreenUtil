# ScreenUtil

Responsive screen-adaptation library for Apple platforms. Scales UI from a fixed design size (e.g. 375×812 from Figma) to the real device. Inspired by `flutter_screenutil`. Pure Swift, zero dependencies. Builds on iOS / macOS / tvOS / watchOS.

This file orients code-review and cleanup work: it maps the code, marks the public contract that must not break, and records the rules that keep the package clean.

## Module Map

Organizing rule: **one platform = one place.** Everything outside `UIKit/` and `SwiftUI/` must be pure cross-platform (Foundation + CoreGraphics only). This makes the macOS build structurally safe and keeps dead code visible.

| Path | Role |
|------|------|
| `Core/ScreenUtil.swift` | Singleton engine (`ScreenUtil.shared`), `configure`, `scale`/`fastScale`, `.w/.h/.sp/.r/.sw/.sh` |
| `Core/ScreenUtilConfiguration.swift` | Config struct + device presets (`iPhone13Pro`, `iPadPro11`, …) |
| `Core/ScaleType.swift` | Protocols (`ScreenScalable`, `ScreenUtilConfigurable`, `ScreenDimensionProvider`) + `ScaleType` |
| `Core/ScalingLimits.swift` | `ScalingLimits` (`.default`/`.strict`/`.relaxed`) |
| `Core/ScreenMetrics.swift` | `ScreenMetrics` snapshot |
| `Internal/ScaleFactorCache.swift` | Captured factors for FastScale/BatchScaler + `cgFloatValue(_:)` Numeric→CGFloat bridge |
| `Internal/Snapshot.swift` | Immutable, atomically-published snapshot of nonisolated-readable scale/metric state |
| `Internal/Log.swift` | Unified-logging endpoints (`os.Logger`) — internal `Log(_:_:level:)` |
| `Metrics/ScreenDimensions.swift` | Platform dimensions snapshot (UIKit-gated reader) |
| `Metrics/DeviceType.swift` | Device/platform classification |
| `Scaling/Numeric+Scaling.swift` | `Int/Float/Double/CGFloat` `.w/.h/.sp/.r/.sw/.sh` |
| `Scaling/CGGeometry+Scaling.swift` | `CGSize/CGPoint/CGRect` scaling (cross-platform) |
| `Scaling/FastScale.swift` | `FastScale` capture-once struct for hot loops + `withFastScale` |
| `Scaling/BatchScaling.swift` | `BatchScaler` / `withBatchScaler` for bulk scaling |
| `UIKit/UIFont+Scaling.swift` | `UIFont` scaled helpers (`#if canImport(UIKit)`) |
| `UIKit/UIView+Scaling.swift` | `UIView` constraint/styling + `NSLayoutConstraint.updateConstant` |
| `UIKit/UIEdgeInsets+Scaling.swift` | `UIEdgeInsets.scaled(...)` |
| `SwiftUI/Environment+ScreenUtil.swift` | `EnvironmentValues.screenUtil` (injects `.shared`) |
| `Debug/ScreenUtilDebug.swift` | `enum` namespace: debug logging, benchmarking, overlay |

## Public Contract (must not break)

Anything not reachable from this set is a removal/merge candidate.

- `ScreenUtil.shared` + `configure(with:)` — singleton, configured once at launch.
- Numeric scaling: `.w .h .sp .r .sw .sh`.
- `ScreenUtilConfiguration` (+ presets) and `ScalingLimits`.
- `FastScale` / `withFastScale`, `BatchScaler` / `withBatchScaler`.
- SwiftUI: `EnvironmentValues.screenUtil`.
- UIKit: `UIFont.systemFont(…, scaled:)`, `UIView` helpers, `UIEdgeInsets.scaled`.

## Review Checklist (when editing)

- Keep **zero dependencies** — `Package.swift` `dependencies: []` stays empty.
- **One platform = one place**: UIKit code only under `UIKit/` (or `#if canImport(UIKit)` blocks); SwiftUI only under `SwiftUI/`. Never bare `import UIKit` in cross-platform files — breaks macOS.
- Builds under `-strict-concurrency=complete` — no new concurrency warnings.
- `ScreenUtil` is compiler-verified `Sendable` (atomic `Snapshot`; no `@unchecked`). New shared state must be `Sendable` / atomic.
- Bulk APIs accept `[T: Numeric]` — route through `cgFloatValue(_:)` so `CGFloat`/`Int64`/etc don't silently scale to zero.
- Removing code: confirm it's not reachable from the Public Contract and not referenced in `Tests/` or `Examples/`.
- Verify with `swift build` **and** `swift test` on macOS (catches the platform-isolation regressions).

## Build & Test

```bash
swift build
swift test
```
