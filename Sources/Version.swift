///
/// Version.swift
///

import Foundation

/// A strongly-typed, type-safe representation of a semantic version.
public struct Version: Hashable {
    public let major: UInt
    public let minor: UInt
    public let patch: UInt
    
    /// Optional build or prerelease identifiers (e.g., "alpha", "beta", "rc1", etc)
    public let label: String?
    
    public let build: String?
    
    public init(major: UInt, minor: UInt = 0, patch: UInt = 0, build: String? = nil, label: String? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.build = build
        self.label = label
    }
    
    /// Represents `0.0.0`
    public static let null = Version(major: 0)
}


