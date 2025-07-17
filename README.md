# Version

[![Swift Version](https://img.shields.io/badge/Swift-5.6+-orange.svg)](https://swift.org/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Swift Tests](https://github.com/inekipelov/swift-run-environment/actions/workflows/swift.yml/badge.svg)](https://github.com/inekipelov/swift-run-environment/actions/workflows/swift.yml)  
[![iOS](https://img.shields.io/badge/iOS-9.0+-blue.svg)](https://developer.apple.com/ios/)
[![macOS](https://img.shields.io/badge/macOS-10.13+-white.svg)](https://developer.apple.com/macos/)
[![tvOS](https://img.shields.io/badge/tvOS-9.0+-black.svg)](https://developer.apple.com/tvos/)
[![watchOS](https://img.shields.io/badge/watchOS-2.0+-orange.svg)](https://developer.apple.com/watchos/)

Representation and comparison of semantic versions in Swift.

Based on [semantic versioning](https://semver.org/).

## Usage

```swift
import Version

// Creating versions
let version1 = Version(major: 1, minor: 2, patch: 3)
let version2: Version = "2.0.0"
let version3: Version = "1.0.0-beta.1"

// Comparing versions
version1 < version2  // true
version1 == "1.2.3"  // true

// Working with ranges
let range = Version(major: 1)...Version(major: 2)
range.contains(version1)  // true

// Foundation integration
let bundle = Bundle.main
let appVersion = bundle.version  // Version

// StoreKit integration (iOS 16.0+)
#if canImport(StoreKit)
import StoreKit
let transaction: AppTransaction = ...
let originalVersion = transaction.originalVersion  // Version
#endif
```

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/inekipelov/swift-version.git", from: "1.0.0")
]
```