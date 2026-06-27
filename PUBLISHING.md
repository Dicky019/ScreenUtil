# Publishing ScreenUtil

How to cut a release of ScreenUtil to Swift Package Manager and Swift Package
Index. Run these yourself — they need your GitHub credentials.

## Channels at a glance

| Channel | Account needed | Mechanism |
|---------|----------------|-----------|
| Swift Package Manager | GitHub (repo admin) | git tag + GitHub Release |
| Swift Package Index | GitHub only | one-time PR to the package list |

## 0. Prepare accounts (one-time)

Do every box here **before** the first release. Tick each one off:

- [ ] **GitHub** — you already own `Dicky019/ScreenUtil` with push + Release rights. Nothing to set up. Optional: install the `gh` CLI (`brew install gh && gh auth login`) to cut Releases from the terminal.
- [ ] **Swift Package Index** — no separate account; it authenticates with GitHub. Registration is a one-time submission of your repo URL via the "Add a Package" form on swiftpackageindex.com (or a PR to https://github.com/SwiftPackageIndex/PackageList). Do this once; later tags are picked up automatically.

When both boxes are ticked you have every credential needed to publish — move on to the repo settings.

## 0b. Repo settings (one-time, GitHub "About" panel or API)

The repo's public metadata should match the package before you announce it.
Current state understates it (description says "iOS apps" only; license shows
"Other"). Fix via the repo's **About** gear on github.com, or the API below.

- [ ] **Description** → broaden beyond iOS:
  > Thread-safe responsive screen adaptation for Apple platforms (iOS, macOS, tvOS, watchOS). Scale UI from a fixed design size to the real device. Inspired by flutter_screenutil.
- [ ] **Topics** → add `macos`, `tvos`, `watchos`, `screen-adaptation`, `swift-package-manager` (keep existing `ios`, `swift`, `swiftui`, `uikit`, `responsive-design`).
- [ ] **Website / homepage** → set to the Swift Package Index page once §3 is done: `https://swiftpackageindex.com/Dicky019/ScreenUtil`.
- [ ] **License badge** → confirm the repo sidebar shows **Apache-2.0** (not "Other"). The `LICENSE` file is already standard Apache-2.0; if it still reads "Other", re-touch and push the file so GitHub re-runs license detection.

Optional one-shot via API (needs the `gh` CLI authenticated):

```bash
gh repo edit Dicky019/ScreenUtil \
  --description "Thread-safe responsive screen adaptation for Apple platforms (iOS, macOS, tvOS, watchOS). Scale UI from a fixed design size to the real device. Inspired by flutter_screenutil." \
  --homepage "https://swiftpackageindex.com/Dicky019/ScreenUtil" \
  --add-topic macos --add-topic tvos --add-topic watchos \
  --add-topic screen-adaptation --add-topic swift-package-manager
```

## 1. Pre-flight checklist

- [ ] On `main`, working tree clean, latest pulled.
- [ ] `swift build` and `swift test` green (108 tests).
- [ ] `CHANGELOG.md` has a dated `## [1.0.0]` section.

```bash
swift build && swift test
```

## 2. Tag and GitHub Release (SPM)

SPM resolves straight from the git tag — tagging *is* the SPM release.

```bash
git tag -a 1.0.0 -m "ScreenUtil 1.0.0"
git push origin 1.0.0
```

Then create the GitHub Release from tag `1.0.0` (UI or `gh`):

```bash
gh release create 1.0.0 --title "1.0.0" --notes-from-tag
```

Paste the `CHANGELOG.md` 1.0.0 notes into the release body.

**Verify:** in a scratch dir, a package depending on `from: "1.0.0"` resolves:

```bash
mkdir /tmp/su-check && cd /tmp/su-check && swift package init --type executable
# add .package(url: "https://github.com/Dicky019/ScreenUtil", from: "1.0.0") then:
swift build
```

## 3. Swift Package Index

One-time: submit `https://github.com/Dicky019/ScreenUtil` via the Add-a-Package
form (or a PR to SwiftPackageIndex/PackageList). After that, SPI picks up new
tags automatically. `.spi.yml` already tells it to build docs for `ScreenUtil`.

> **Status (2026-06-28): approval queued, not yet live.** Submission is filed as
> SwiftPackageIndex/PackageList issue
> [#14194](https://github.com/SwiftPackageIndex/PackageList/issues/14194)
> (label `Add Package`). The SPI bot has acknowledged it and opened auto-approval
> PR [#14195](https://github.com/SwiftPackageIndex/PackageList/pull/14195)
> ("We will approve and add these packages with #14195"). Once #14195 merges, SPI
> indexes the repo and runs its build; until then the package page 404s — that is
> expected, not a failure on our side.

**Verify (once the issue closes):** the package page
`https://swiftpackageindex.com/Dicky019/ScreenUtil` shows a green build matrix
and the `1.0.0` version. Only then set the repo homepage to that URL.

## 4. Post-release

Reopen the changelog for the next cycle — add at the top of `CHANGELOG.md`:

```markdown
## [Unreleased]
```
