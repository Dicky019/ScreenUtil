# ScreenUtil Demo Apps

Two runnable iOS 17 demo apps — one pure SwiftUI, one pure UIKit — each a single
polished **GitHub profile page** whose every dimension flows through ScreenUtil.
Designed on the **iPhone 12 baseline (390×844)**: on an iPhone 12 the UI renders
1:1, and on a larger device (e.g. iPhone 17 Pro Max) the same design scales up
proportionally. Screenshot both to show the adaptation.

## Run

```bash
cd Examples
brew install xcodegen          # one-time
xcodegen generate
open ScreenUtilExamples.xcodeproj
```

Pick a scheme and run:

- **ScreenUtilSwiftUIDemo** — pure SwiftUI (`@Observable` model, `NavigationStack`, `@Environment(\.screenUtil)`).
- **ScreenUtilUIKitDemo** — pure UIKit (`UIScene`, Auto Layout, stored-property subviews).

## What it shows

Each app composes the same sections, all scaled from the design baseline:

| Section | ScreenUtil APIs exercised |
|---------|---------------------------|
| **Header** (banner, avatar, name, bio) | numeric `.w .h .sp .r`, `CGSize.scaled`, `UIView.cornerRadius/borderWidth/size`, `UIFont.systemFont(…, scaled:)` |
| **Stats row** (repos/followers/following) | `BatchScaler.fontSizes`, `UIEdgeInsets.scaled` |
| **Highlights** (horizontal strip) | `FastScale` (`width/height/text/size/point/rect`), `withFastScale`, `BatchScaler.points/.rects` |
| **Tag chips** | `BatchScaler.widths/.radii`, `withBatchScaler` |
| **Device & Scaling card** | `getScreenMetrics`, `screenWidth/Height`, `scaleWidth/Height/Text`, `deviceType`, `safeArea*`, `statusBarHeight`, `scale/fastScale(for:scaleType:)` (all `ScaleType` cases), `UIFont.customFont`, and a one-line "bulk self-test" covering `BatchScaler.heights/.sizes/.scale`, `BatchScaler.edgeInsets` (UIKit), `CGRect.scaled/.responsive` |

### Real data + offline-safe

The profile loads from the live GitHub public API
(`api.github.com/users/{login}`) — real avatar, repo and follower counts. On any
failure (offline / rate-limited) it falls back to a bundled `sample-user.json`,
so the demo (and your screenshots) never show a spinner or empty state.

## Verify the scaling

Open the **Device & Scaling** card and read `scaleW · scaleH`:

- iPhone 12 → `1.00 · 1.00` (renders exactly as designed)
- iPhone 17 Pro Max → ~`1.13 · 1.13` (everything scaled up proportionally)

> The generated `ScreenUtilExamples.xcodeproj` is not committed; regenerate it with `xcodegen generate`.
