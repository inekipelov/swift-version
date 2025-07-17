import XCTest
@testable import Version

final class VersionPerformanceTests: XCTestCase {
    
    // MARK: - Parsing Performance Tests
    
    func testParsingPerformance() {
        let versions = [
            "1.0.0",
            "2.1.3",
            "1.0.0-alpha",
            "1.0.0+build123",
            "1.0.0-alpha+build123",
            "1.0.0-alpha.1",
            "1.0.0-0.3.7",
            "1.0.0-x.7.z.92",
            "10.20.30",
            "1.1.2-prerelease+meta"
        ]
        
        measure {
            for _ in 0..<1000 {
                for versionString in versions {
                    _ = try? Version.parse(from: versionString)
                }
            }
        }
    }
    
    func testStringLiteralPerformance() {
        measure {
            for _ in 0..<1000 {
                let _: Version = "1.2.3"
                let _: Version = "2.0.0-alpha"
                let _: Version = "1.0.0+build123"
                let _: Version = "3.1.4-beta+exp.sha.5114f85"
            }
        }
    }
    
    // MARK: - Comparison Performance Tests
    
    func testComparisonPerformance() {
        let versions = (0..<100).map { i in
            Version(major: UInt(i % 10), minor: UInt(i % 5), patch: UInt(i % 3))
        }
        
        measure {
            for i in 0..<versions.count {
                for j in (i+1)..<versions.count {
                    _ = versions[i] < versions[j]
                    _ = versions[i] == versions[j]
                }
            }
        }
    }
    
    // MARK: - String Conversion Performance Tests
    
    func testStringConversionPerformance() {
        let versions = [
            Version(major: 1, minor: 0, patch: 0),
            Version(major: 2, minor: 1, patch: 3),
            Version(major: 1, minor: 0, patch: 0, label: "alpha"),
            Version(major: 1, minor: 0, patch: 0, build: "build123"),
            Version(major: 1, minor: 0, patch: 0, build: "build123", label: "alpha"),
        ]
        
        measure {
            for _ in 0..<1000 {
                for version in versions {
                    _ = version.description
                }
            }
        }
    }
    
    // MARK: - Sorting Performance Tests
    
    func testSortingPerformance() {
        var versions: [Version] = []
        for i in 0..<1000 {
            let version = Version(
                major: UInt(i % 10),
                minor: UInt(i % 8),
                patch: UInt(i % 6),
                label: i % 3 == 0 ? "alpha" : nil
            )
            versions.append(version)
        }
        
        measure {
            versions.sort()
        }
    }
}
