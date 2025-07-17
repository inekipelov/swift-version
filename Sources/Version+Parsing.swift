//
//  Version+Parsing.swift
//

import Foundation

// MARK: - Version Parsing Errors
public enum VersionParsingError: Error, LocalizedError {
    case invalidRawString(String)
    case invalidMajorVersion(String)
    case invalidMinorVersion(String)
    case invalidPatchVersion(String)
    case invalidLabel(String)
    case invalidBuild(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidRawString(let input):
            return "Invalid version format: '\(input)'"
        case .invalidMajorVersion(let version):
            return "Invalid major version: '\(version)'"
        case .invalidMinorVersion(let version):
            return "Invalid minor version: '\(version)'"
        case .invalidPatchVersion(let version):
            return "Invalid patch version: '\(version)'"
        case .invalidLabel(let label):
            return "Invalid pre-release label: '\(label)'"
        case .invalidBuild(let build):
            return "Invalid build metadata: '\(build)'"
        }
    }
}

// MARK: - Version Parsing Implementation
extension Version {
    /// Unified parsing method with comprehensive validation
    /// - Parameter string: The version string to parse
    /// - Returns: A Version instance
    /// - Throws: VersionParsingError if parsing fails
    static func parse(from string: String) throws -> Version {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            throw VersionParsingError.invalidRawString(string)
        }
        
        // Split by "+" to extract build metadata
        let buildParts = trimmed.split(separator: "+", maxSplits: 1, omittingEmptySubsequences: false)
        let mainVersion = String(buildParts[0])
        let build = buildParts.count > 1 ? String(buildParts[1]) : nil
        
        // Validate build metadata if present
        if let build = build {
            try validateBuildMetadata(build)
        }
        
        // Split main version by "-" to extract pre-release label
        let labelParts = mainVersion.split(separator: "-", maxSplits: 1, omittingEmptySubsequences: false)
        let versionNumbers = String(labelParts[0])
        let label = labelParts.count > 1 ? String(labelParts[1]) : nil
        
        // Validate label if present
        if let label = label {
            try validateLabel(label)
        }
        
        // Parse version numbers
        let numbers = versionNumbers.split(separator: ".").map(String.init)
        
        guard numbers.count >= 1 && numbers.count <= 3 else {
            throw VersionParsingError.invalidRawString(string)
        }
        
        // Parse and validate major version
        guard let major = UInt(numbers[0]) else {
            throw VersionParsingError.invalidMajorVersion(numbers[0])
        }
        
        // Parse and validate minor version (default to 0)
        let minor: UInt
        if numbers.count >= 2 {
            guard let parsedMinor = UInt(numbers[1]) else {
                throw VersionParsingError.invalidMinorVersion(numbers[1])
            }
            minor = parsedMinor
        } else {
            minor = 0
        }
        
        // Parse and validate patch version (default to 0)
        let patch: UInt
        if numbers.count >= 3 {
            guard let parsedPatch = UInt(numbers[2]) else {
                throw VersionParsingError.invalidPatchVersion(numbers[2])
            }
            patch = parsedPatch
        } else {
            patch = 0
        }
        
        return Version(major: major, minor: minor, patch: patch, build: build, label: label)
    }
}

// MARK: - Private Validation Methods
private extension Version {
    
    static func validateLabel(_ label: String) throws {
        guard !label.isEmpty else {
            throw VersionParsingError.invalidLabel(label)
        }
        
        // SemVer: Pre-release identifiers must comprise only ASCII alphanumerics and hyphens
        let validCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-."))
        guard label.unicodeScalars.allSatisfy({ validCharacters.contains($0) }) else {
            throw VersionParsingError.invalidLabel(label)
        }
        
        // SemVer: Pre-release identifiers must not be empty
        let identifiers = label.split(separator: ".")
        guard identifiers.allSatisfy({ !$0.isEmpty }) else {
            throw VersionParsingError.invalidLabel(label)
        }
        
        // Check for double dots which would create empty identifiers
        if label.contains("..") {
            throw VersionParsingError.invalidLabel("Label contains empty identifiers: '\(label)'")
        }
        
        // SemVer: Numeric identifiers must not include leading zeros
        for identifier in identifiers {
            if identifier.allSatisfy({ $0.isNumber }) && identifier.count > 1 && identifier.first == "0" {
                throw VersionParsingError.invalidLabel("Numeric identifier cannot have leading zeros: '\(identifier)'")
            }
        }
    }
    
    static func validateBuildMetadata(_ build: String) throws {
        guard !build.isEmpty else {
            throw VersionParsingError.invalidBuild(build)
        }
        
        // SemVer: Build metadata may comprise only ASCII alphanumerics and hyphens
        let validCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-."))
        guard build.unicodeScalars.allSatisfy({ validCharacters.contains($0) }) else {
            throw VersionParsingError.invalidBuild(build)
        }
        
        // Check for double dots which would create empty identifiers
        if build.contains("..") {
            throw VersionParsingError.invalidBuild(build)
        }
    }
}

// MARK: - Array Safe Subscript (shared utility)
extension Array {
    subscript(safe index: Int) -> Element? {
        (startIndex..<endIndex).contains(index) ? self[index] : nil
    }
}
