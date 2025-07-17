import XCTest
@testable import Version

final class VersionTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testBasicInitialization() {
        let version = Version(major: 1, minor: 2, patch: 3)
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 3)
        XCTAssertNil(version.label)
        XCTAssertNil(version.build)
    }
    
    func testInitializationWithDefaults() {
        let version = Version(major: 1)
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
    }
    
    func testInitializationWithLabelAndBuild() {
        let version = Version(major: 1, minor: 2, patch: 3, build: "abc123", label: "alpha")
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 3)
        XCTAssertEqual(version.label, "alpha")
        XCTAssertEqual(version.build, "abc123")
    }
    
    // MARK: - String Parsing Tests
    
    func testValidStringParsing() throws {
        let testCases: [(String, Version)] = [
            ("1.0.0", Version(major: 1, minor: 0, patch: 0)),
            ("2.1.3", Version(major: 2, minor: 1, patch: 3)),
            ("1.0.0-alpha", Version(major: 1, minor: 0, patch: 0, label: "alpha")),
            ("1.0.0+build123", Version(major: 1, minor: 0, patch: 0, build: "build123")),
            ("1.0.0-alpha+build123", Version(major: 1, minor: 0, patch: 0, build: "build123", label: "alpha")),
            ("1.0.0-alpha.1", Version(major: 1, minor: 0, patch: 0, label: "alpha.1")),
            ("1.0.0-0.3.7", Version(major: 1, minor: 0, patch: 0, label: "0.3.7")),
            ("1.0.0-x.7.z.92", Version(major: 1, minor: 0, patch: 0, label: "x.7.z.92")),
            ("1", Version(major: 1, minor: 0, patch: 0)),
            ("1.2", Version(major: 1, minor: 2, patch: 0)),
        ]
        
        for (input, expected) in testCases {
            let parsed = try Version.parse(from: input)
            XCTAssertEqual(parsed, expected, "Failed to parse '\(input)'")
        }
    }
    
    func testInvalidStringParsing() {
        let invalidCases = [
            "",
            "   ",
            "a.b.c",
            "1.a.0",
            "1.0.a",
            "1.0.0-",
            "1.0.0+",
            "1.0.0-+",
            "1.0.0-alpha..beta",
            "1.0.0-01", // Leading zero in numeric identifier
            "1.0.0-alpha@beta", // Invalid character
        ]
        
        for invalidInput in invalidCases {
            XCTAssertThrowsError(try Version.parse(from: invalidInput), "Should throw error for '\(invalidInput)'") { error in
                XCTAssertTrue(error is VersionParsingError, "Expected VersionParsingError for '\(invalidInput)', got \(error)")
            }
        }
    }
    
    // MARK: - String Literal Tests
    
    func testStringLiteralInitialization() {
        let version: Version = "1.2.3"
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 3)
    }
    
    func testInvalidStringLiteralFallback() {
        let version: Version = "invalid"
        XCTAssertEqual(version, Version.null)
    }
    
    // MARK: - LosslessStringConvertible Tests
    
    func testLosslessStringConvertible() {
        XCTAssertEqual(Version("1.2.3"), Version(major: 1, minor: 2, patch: 3))
        XCTAssertEqual(Version("1.0.0-alpha"), Version(major: 1, minor: 0, patch: 0, label: "alpha"))
        
        // Test LosslessStringConvertible specifically with explicit initializer
        let validVersion = Version.init("1.2.3")  // Uses LosslessStringConvertible init?(_:)
        let invalidVersion = Version.init("invalid")  // Uses LosslessStringConvertible init?(_:)
        
        XCTAssertEqual(validVersion, Version(major: 1, minor: 2, patch: 3))
        XCTAssertNil(invalidVersion, "Invalid string should return nil through LosslessStringConvertible")
        
        // Test specific invalid cases through LosslessStringConvertible
        let invalidResult1 = Version.init("1.0.0-01")
        let invalidResult2 = Version.init("1.0.0-alpha@beta")
        
        XCTAssertNil(invalidResult1, "Leading zero should be invalid")
        XCTAssertNil(invalidResult2, "Invalid character should be invalid")
    }
    
    // MARK: - String Description Tests
    
    func testStringDescription() {
        XCTAssertEqual(Version(major: 1, minor: 2, patch: 3).description, "1.2.3")
        XCTAssertEqual(Version(major: 1, minor: 0, patch: 0).description, "1.0.0")
        XCTAssertEqual(Version(major: 1, minor: 2, patch: 3, label: "alpha").description, "1.2.3-alpha")
        XCTAssertEqual(Version(major: 1, minor: 2, patch: 3, build: "build123").description, "1.2.3+build123")
        XCTAssertEqual(Version(major: 1, minor: 2, patch: 3, build: "build123", label: "alpha").description, "1.2.3-alpha+build123")
    }
    
    // MARK: - Comparison Tests
    
    func testVersionComparison() {
        let v1 = Version(major: 1, minor: 0, patch: 0)
        let v2 = Version(major: 2, minor: 0, patch: 0)
        let v3 = Version(major: 1, minor: 1, patch: 0)
        let v4 = Version(major: 1, minor: 0, patch: 1)
        
        XCTAssertTrue(v1 < v2)
        XCTAssertTrue(v1 < v3)
        XCTAssertTrue(v1 < v4)
        XCTAssertTrue(v3 < v2)
        XCTAssertTrue(v4 < v3)
    }
    
    func testPreReleaseComparison() {
        let normal = Version(major: 1, minor: 0, patch: 0)
        let alpha = Version(major: 1, minor: 0, patch: 0, label: "alpha")
        let beta = Version(major: 1, minor: 0, patch: 0, label: "beta")
        let rc = Version(major: 1, minor: 0, patch: 0, label: "rc")
        
        // Pre-release versions have lower precedence than normal version
        XCTAssertTrue(alpha < normal)
        XCTAssertTrue(beta < normal)
        XCTAssertTrue(rc < normal)
        
        // Compare pre-release versions lexically
        XCTAssertTrue(alpha < beta)
        XCTAssertTrue(beta < rc)
    }
    
    func testBuildMetadataComparison() {
        let v1 = Version(major: 1, minor: 0, patch: 0, build: "build1")
        let v2 = Version(major: 1, minor: 0, patch: 0, build: "build2")
        let v3 = Version(major: 1, minor: 0, patch: 0)
        
        XCTAssertTrue(v1 < v2)
        XCTAssertTrue(v3 < v1) // No build < with build
    }
    
    // MARK: - Equality Tests
    
    func testVersionEquality() {
        let v1 = Version(major: 1, minor: 2, patch: 3)
        let v2 = Version(major: 1, minor: 2, patch: 3)
        let v3 = Version(major: 1, minor: 2, patch: 4)
        
        XCTAssertEqual(v1, v2)
        XCTAssertNotEqual(v1, v3)
        XCTAssertEqual(v1, "1.2.3")
    }
    
    func testVersionEqualityWithLabelsAndBuild() {
        let v1 = Version(major: 1, minor: 0, patch: 0, build: "build1", label: "alpha")
        let v2 = Version(major: 1, minor: 0, patch: 0, build: "build1", label: "alpha")
        let v3 = Version(major: 1, minor: 0, patch: 0, build: "build2", label: "alpha")
        let v4 = Version(major: 1, minor: 0, patch: 0, build: "build1", label: "beta")
        
        XCTAssertEqual(v1, v2)
        XCTAssertNotEqual(v1, v3)
        XCTAssertNotEqual(v1, v4)
    }
    
    // MARK: - Codable Tests
    
    func testCodableEncoding() throws {
        let version = Version(major: 1, minor: 2, patch: 3, build: "build123", label: "alpha")
        let data = try JSONEncoder().encode(version)
        let decoded = try JSONDecoder().decode(Version.self, from: data)
        
        XCTAssertEqual(version, decoded)
    }
    
    func testCodableEncodingSimple() throws {
        let version = Version(major: 1, minor: 2, patch: 3)
        let data = try JSONEncoder().encode(version)
        let jsonString = String(data: data, encoding: .utf8)
        
        XCTAssertEqual(jsonString, "\"1.2.3\"")
    }
    
    // MARK: - Hashable Tests
    
    func testHashable() {
        let v1 = Version(major: 1, minor: 2, patch: 3)
        let v2 = Version(major: 1, minor: 2, patch: 3)
        let v3 = Version(major: 1, minor: 2, patch: 4)
        
        XCTAssertEqual(v1.hashValue, v2.hashValue)
        XCTAssertNotEqual(v1.hashValue, v3.hashValue)
        
        let set: Set<Version> = [v1, v2, v3]
        XCTAssertEqual(set.count, 2) // v1 and v2 should be considered the same
    }
    
    // MARK: - Range Tests
    
    func testVersionRanges() {
        let v1 = Version(major: 1, minor: 0, patch: 0)
        let v2 = Version(major: 2, minor: 0, patch: 0)
        let v3 = Version(major: 1, minor: 5, patch: 0)
        
        let closedRange = v1...v2
        let openRange = v1..<v2
        
        XCTAssertTrue(closedRange.contains(v1))
        XCTAssertTrue(closedRange.contains(v3))
        XCTAssertTrue(closedRange.contains(v2))
        
        XCTAssertTrue(openRange.contains(v1))
        XCTAssertTrue(openRange.contains(v3))
        XCTAssertFalse(openRange.contains(v2))
    }
    
    // MARK: - Error Handling Tests
    
    func testSpecificErrorTypes() {
        XCTAssertThrowsError(try Version.parse(from: "a.0.0")) { error in
            XCTAssertTrue(error is VersionParsingError)
            if case .invalidMajorVersion(let version) = error as? VersionParsingError {
                XCTAssertEqual(version, "a")
            } else {
                XCTFail("Expected invalidMajorVersion error")
            }
        }
        
        XCTAssertThrowsError(try Version.parse(from: "1.a.0")) { error in
            XCTAssertTrue(error is VersionParsingError)
            if case .invalidMinorVersion(let version) = error as? VersionParsingError {
                XCTAssertEqual(version, "a")
            } else {
                XCTFail("Expected invalidMinorVersion error")
            }
        }
        
        XCTAssertThrowsError(try Version.parse(from: "1.0.a")) { error in
            XCTAssertTrue(error is VersionParsingError)
            if case .invalidPatchVersion(let version) = error as? VersionParsingError {
                XCTAssertEqual(version, "a")
            } else {
                XCTFail("Expected invalidPatchVersion error")
            }
        }
    }
    
    // MARK: - SemVer Validation Tests
    
    func testSemVerValidation() {
        // Valid pre-release identifiers
        XCTAssertNoThrow(try Version.parse(from: "1.0.0-alpha"))
        XCTAssertNoThrow(try Version.parse(from: "1.0.0-alpha.1"))
        XCTAssertNoThrow(try Version.parse(from: "1.0.0-0.3.7"))
        XCTAssertNoThrow(try Version.parse(from: "1.0.0-x.7.z.92"))
        
        // Invalid pre-release identifiers
        XCTAssertThrowsError(try Version.parse(from: "1.0.0-01")) // Leading zero
        XCTAssertThrowsError(try Version.parse(from: "1.0.0-alpha..beta")) // Empty identifier
        XCTAssertThrowsError(try Version.parse(from: "1.0.0-alpha@beta")) // Invalid character
        
        // Valid build metadata
        XCTAssertNoThrow(try Version.parse(from: "1.0.0+20130313144700"))
        XCTAssertNoThrow(try Version.parse(from: "1.0.0+exp.sha.5114f85"))
        
        // Invalid build metadata - empty build should fail
        XCTAssertThrowsError(try Version.parse(from: "1.0.0+")) // Empty build
    }
    
    // MARK: - Edge Cases
    
    func testEdgeCases() {
        // Large version numbers
        let largeVersion = Version(major: UInt.max, minor: UInt.max, patch: UInt.max)
        XCTAssertEqual(largeVersion.description, "\(UInt.max).\(UInt.max).\(UInt.max)")
        
        // Whitespace handling
        XCTAssertNoThrow(try Version.parse(from: "  1.2.3  "))
        XCTAssertEqual(try Version.parse(from: "  1.2.3  "), Version(major: 1, minor: 2, patch: 3))
        
        // Null version
        XCTAssertEqual(Version.null, Version(major: 0, minor: 0, patch: 0))
    }
}
