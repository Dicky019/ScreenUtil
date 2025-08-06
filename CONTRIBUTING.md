# Contributing to ScreenUtil

Thank you for your interest in contributing to ScreenUtil! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Release Process](#release-process)

## Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct. Please be respectful and inclusive in all interactions.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When creating a bug report, include:

- **Clear and descriptive title**
- **Detailed description** of the problem
- **Steps to reproduce** the issue
- **Expected behavior** vs **actual behavior**
- **Environment details**:
  - iOS/tvOS version
  - Device/simulator
  - ScreenUtil version
  - Xcode version
- **Code example** that reproduces the issue
- **Screenshots** if applicable

### Suggesting Enhancements

Enhancement suggestions are welcome! Please include:

- **Clear description** of the proposed feature
- **Use case** and why it would be useful
- **Implementation approach** (if you have ideas)
- **Mockups or examples** if applicable

### Pull Requests

We welcome pull requests! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch** from `main`
3. **Make your changes** following our coding standards
4. **Add tests** for new functionality
5. **Update documentation** if needed
6. **Submit a pull request**

## Development Setup

### Prerequisites

- Xcode 15.0+
- iOS 12.0+ / tvOS 12.0+ simulator or device
- Swift 6.1+

### Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/Dicky019/ScreenUtil.git
   cd ScreenUtil
   ```

2. **Open in Xcode**
   ```bash
   open Package.swift
   ```

3. **Run tests**
   ```bash
   swift test
   ```

### Project Structure

```
ScreenUtil/
├── Package.swift              # Package configuration
├── Sources/
│   └── ScreenUtil/
│       ├── ScreenUtil.swift   # Main ScreenUtil class
│       ├── Extensions/        # CGFloat extensions
│       └── SwiftUI/           # SwiftUI support
└── Tests/
    └── ScreenUtilTests/       # Unit tests
```

## Coding Standards

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) and use SwiftLint for consistency.

### Code Formatting

- Use **4 spaces** for indentation (no tabs)
- Maximum line length: **120 characters**
- Use **camelCase** for variables and functions
- Use **PascalCase** for types and protocols
- Use **snake_case** for file names

### Documentation

- **Document all public APIs** with Swift documentation comments
- Use **`///`** for single-line documentation
- Use **`/**`** for multi-line documentation
- Include **parameter descriptions** and **return values**
- Add **usage examples** for complex APIs

Example:
```swift
/// Scales a value based on the current screen width.
/// - Parameter value: The value to scale
/// - Returns: The scaled value
/// - Note: This method automatically updates when the device orientation changes
public func scaleWidth(_ value: CGFloat) -> CGFloat {
    return value * scaleWidth
}
```

### Naming Conventions

- **Clear and descriptive** names
- **Avoid abbreviations** unless widely understood
- **Use Swift naming conventions**
- **Be consistent** across the codebase

## Testing

### Test Requirements

- **All new features** must include tests
- **Bug fixes** must include regression tests
- **Maintain 90%+ code coverage**
- **Test both success and failure cases**

### Running Tests

```bash
# Run all tests
swift test

# Run specific test
swift test --filter ScreenUtilTests

# Run with coverage
swift test --enable-code-coverage
```

### Test Structure

```swift
import XCTest
@testable import ScreenUtil

final class ScreenUtilTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Setup code
    }
    
    override func tearDown() {
        // Cleanup code
        super.tearDown()
    }
    
    func testExample() {
        // Test implementation
    }
}
```

### Test Guidelines

- **One assertion per test** when possible
- **Clear test names** that describe the scenario
- **Arrange-Act-Assert** pattern
- **Test edge cases** and error conditions
- **Mock dependencies** when appropriate

## Pull Request Process

### Before Submitting

1. **Ensure tests pass** locally
2. **Update documentation** if needed
3. **Check code formatting** with SwiftLint
4. **Self-review** your changes

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests added/updated
- [ ] All tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
- [ ] Tests added for new functionality
```

### Review Process

1. **Automated checks** must pass
2. **Code review** by maintainers
3. **Address feedback** and make changes
4. **Maintainer approval** required
5. **Merge to main** branch

## Release Process

### Versioning

We follow [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for backwards-compatible new features
- **PATCH** version for backwards-compatible bug fixes

### Release Checklist

- [ ] **Update version** in Package.swift
- [ ] **Update CHANGELOG.md** with new version
- [ ] **Run full test suite**
- [ ] **Update documentation** if needed
- [ ] **Create release tag**
- [ ] **Publish to GitHub**

### Creating a Release

1. **Update version** in `Package.swift`
2. **Add changelog entry** in `CHANGELOG.md`
3. **Create and push tag**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
4. **Create GitHub release** with changelog

## Getting Help

- **GitHub Issues** - For bugs and feature requests
- **GitHub Discussions** - For questions and general discussion
- **Pull Requests** - For code contributions

## Recognition

Contributors will be recognized in:
- **README.md** contributors section
- **GitHub contributors** page
- **Release notes** for significant contributions

Thank you for contributing to ScreenUtil! 🚀 