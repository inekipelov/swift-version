//
//  RangeVersionTests.swift
//

import XCTest
@testable import Version

final class RangeVersionTests: XCTestCase {
    
    // MARK: - ClosedRange Tests
    
    func testClosedRangeContains() {
        let range = Version(major: 1, minor: 0, patch: 0)...Version(major: 2, minor: 0, patch: 0)
        
        // Test versions within range
        XCTAssertTrue(range.contains(Version(major: 1, minor: 0, patch: 0))) // Lower bound
        XCTAssertTrue(range.contains(Version(major: 1, minor: 5, patch: 10))) // Middle
        XCTAssertTrue(range.contains(Version(major: 2, minor: 0, patch: 0))) // Upper bound
        
        // Test versions outside range
        XCTAssertFalse(range.contains(Version(major: 0, minor: 9, patch: 9))) // Below range
        XCTAssertFalse(range.contains(Version(major: 2, minor: 0, patch: 1))) // Above range
        XCTAssertFalse(range.contains(Version(major: 3, minor: 0, patch: 0))) // Well above range
    }
    
    func testClosedRangePatternMatching() {
        let range = Version(major: 2, minor: 0, patch: 0)...Version(major: 2, minor: 9, patch: 999)
        
        // Test versions that should match
        XCTAssertTrue(range ~= Version(major: 2, minor: 0, patch: 0)) // Lower bound
        XCTAssertTrue(range ~= Version(major: 2, minor: 5, patch: 10)) // Middle
        XCTAssertTrue(range ~= Version(major: 2, minor: 9, patch: 999)) // Upper bound
        
        // Test versions that should not match
        XCTAssertFalse(range ~= Version(major: 1, minor: 9, patch: 999)) // Below range
        XCTAssertFalse(range ~= Version(major: 2, minor: 10, patch: 0)) // Above range
        XCTAssertFalse(range ~= Version(major: 3, minor: 0, patch: 0)) // Well above range
    }
    
    func testClosedRangeInSwitchStatement() {
        let versions = [
            Version(major: 1, minor: 5, patch: 0),
            Version(major: 2, minor: 1, patch: 0),
            Version(major: 2, minor: 9, patch: 999),
            Version(major: 3, minor: 0, patch: 0)
        ]
        
        let range = Version(major: 2, minor: 0, patch: 0)...Version(major: 2, minor: 9, patch: 999)
        var results: [String] = []
        
        for version in versions {
            switch version {
            case range:
                results.append("in range")
            default:
                results.append("out of range")
            }
        }
        
        XCTAssertEqual(results, ["out of range", "in range", "in range", "out of range"])
    }
    
    // MARK: - Range Tests
    
    func testRangeContains() {
        let range = Version(major: 1, minor: 0, patch: 0)..<Version(major: 2, minor: 0, patch: 0)
        
        // Test versions within range
        XCTAssertTrue(range.contains(Version(major: 1, minor: 0, patch: 0))) // Lower bound
        XCTAssertTrue(range.contains(Version(major: 1, minor: 5, patch: 10))) // Middle
        XCTAssertTrue(range.contains(Version(major: 1, minor: 9, patch: 999))) // Near upper bound
        
        // Test versions outside range
        XCTAssertFalse(range.contains(Version(major: 0, minor: 9, patch: 9))) // Below range
        XCTAssertFalse(range.contains(Version(major: 2, minor: 0, patch: 0))) // Upper bound (excluded)
        XCTAssertFalse(range.contains(Version(major: 2, minor: 0, patch: 1))) // Above range
    }
    
    func testRangePatternMatching() {
        let range = Version(major: 1, minor: 0, patch: 0)..<Version(major: 2, minor: 0, patch: 0)
        
        // Test versions that should match
        XCTAssertTrue(range ~= Version(major: 1, minor: 0, patch: 0)) // Lower bound
        XCTAssertTrue(range ~= Version(major: 1, minor: 5, patch: 10)) // Middle
        XCTAssertTrue(range ~= Version(major: 1, minor: 9, patch: 999)) // Near upper bound
        
        // Test versions that should not match
        XCTAssertFalse(range ~= Version(major: 0, minor: 9, patch: 999)) // Below range
        XCTAssertFalse(range ~= Version(major: 2, minor: 0, patch: 0)) // Upper bound (excluded)
        XCTAssertFalse(range ~= Version(major: 2, minor: 1, patch: 0)) // Above range
    }
    
    func testRangeInSwitchStatement() {
        let versions = [
            Version(major: 0, minor: 9, patch: 0),
            Version(major: 1, minor: 0, patch: 0),
            Version(major: 1, minor: 5, patch: 0),
            Version(major: 2, minor: 0, patch: 0),
            Version(major: 2, minor: 1, patch: 0)
        ]
        
        let range = Version(major: 1, minor: 0, patch: 0)..<Version(major: 2, minor: 0, patch: 0)
        var results: [String] = []
        
        for version in versions {
            switch version {
            case range:
                results.append("in range")
            default:
                results.append("out of range")
            }
        }
        
        XCTAssertEqual(results, ["out of range", "in range", "in range", "out of range", "out of range"])
    }
    
    // MARK: - Complex Range Tests
    
    func testComplexRangeScenarios() {
        // Test with prerelease versions
        let prereleaseRange = Version(major: 1, minor: 0, patch: 0, label: "alpha")...Version(major: 1, minor: 0, patch: 0, label: "gamma")
        
        XCTAssertTrue(prereleaseRange.contains(Version(major: 1, minor: 0, patch: 0, label: "alpha")))
        XCTAssertTrue(prereleaseRange.contains(Version(major: 1, minor: 0, patch: 0, label: "beta")))
        XCTAssertTrue(prereleaseRange.contains(Version(major: 1, minor: 0, patch: 0, label: "gamma")))
        XCTAssertFalse(prereleaseRange.contains(Version(major: 1, minor: 0, patch: 0, label: "zeta"))) // "zeta" > "gamma"
        
        // Test with build metadata
        let buildRange = Version(major: 1, minor: 0, patch: 0, build: "100")...Version(major: 1, minor: 0, patch: 0, build: "200")
        
        XCTAssertTrue(buildRange.contains(Version(major: 1, minor: 0, patch: 0, build: "100")))
        XCTAssertTrue(buildRange.contains(Version(major: 1, minor: 0, patch: 0, build: "150")))
        XCTAssertTrue(buildRange.contains(Version(major: 1, minor: 0, patch: 0, build: "200")))
        XCTAssertFalse(buildRange.contains(Version(major: 1, minor: 0, patch: 0, build: "250")))
    }
    
    func testRangeWithSameVersions() {
        // Test range where lower and upper bounds are the same
        let singleVersionRange = Version(major: 1, minor: 0, patch: 0)...Version(major: 1, minor: 0, patch: 0)
        
        XCTAssertTrue(singleVersionRange.contains(Version(major: 1, minor: 0, patch: 0)))
        XCTAssertFalse(singleVersionRange.contains(Version(major: 1, minor: 0, patch: 1)))
        XCTAssertFalse(singleVersionRange.contains(Version(major: 0, minor: 9, patch: 9)))
    }
    
    func testRangeEdgeCases() {
        // Test with null version
        let nullRange = Version.null...Version(major: 1, minor: 0, patch: 0)
        
        XCTAssertTrue(nullRange.contains(Version.null))
        XCTAssertTrue(nullRange.contains(Version(major: 0, minor: 5, patch: 0)))
        XCTAssertTrue(nullRange.contains(Version(major: 1, minor: 0, patch: 0)))
        XCTAssertFalse(nullRange.contains(Version(major: 1, minor: 0, patch: 1)))
        
        // Test with very large version numbers
        let largeRange = Version(major: 100, minor: 0, patch: 0)...Version(major: 999, minor: 999, patch: 999)
        
        XCTAssertTrue(largeRange.contains(Version(major: 500, minor: 500, patch: 500)))
        XCTAssertFalse(largeRange.contains(Version(major: 99, minor: 999, patch: 999)))
        XCTAssertFalse(largeRange.contains(Version(major: 1000, minor: 0, patch: 0)))
    }
    
    // MARK: - Performance Tests
    
    func testRangePerformance() {
        let range = Version(major: 1, minor: 0, patch: 0)...Version(major: 10, minor: 0, patch: 0)
        let testVersions = (0..<1000).map { Version(major: UInt($0 % 15), minor: 0, patch: 0) }
        
        measure {
            for version in testVersions {
                _ = range.contains(version)
            }
        }
    }
    
    func testPatternMatchingPerformance() {
        let range = Version(major: 1, minor: 0, patch: 0)...Version(major: 10, minor: 0, patch: 0)
        let testVersions = (0..<1000).map { Version(major: UInt($0 % 15), minor: 0, patch: 0) }
        
        measure {
            for version in testVersions {
                _ = range ~= version
            }
        }
    }
}
