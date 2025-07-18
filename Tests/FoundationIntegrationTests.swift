import XCTest
import Foundation
@testable import Version

final class FoundationIntegrationTests: XCTestCase {
    
    // MARK: - Bundle Version Tests
    
    func testBundleVersionExtraction() {
        // Test with main bundle (if available)
        let mainBundle = Bundle.main
        let version = mainBundle.appVersion
        
        // Should always return a valid version (at least null)
        XCTAssertGreaterThanOrEqual(version.major, 0)
        XCTAssertGreaterThanOrEqual(version.minor, 0)
        XCTAssertGreaterThanOrEqual(version.patch, 0)
    }
    
    func testBundleWithMockInfo() {
        // Create a mock bundle with specific info dictionary
        let mockBundle = MockBundle()
        mockBundle.mockInfoDictionary = [
            "CFBundleShortVersionString": "1.2.3",
            "CFBundleVersion": "456"
        ]
        
        let version = mockBundle.appVersion
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 3)
        XCTAssertEqual(version.build, "456")
    }
    
    func testBundleWithInvalidVersion() {
        let mockBundle = MockBundle()
        mockBundle.mockInfoDictionary = [
            "CFBundleShortVersionString": "invalid",
            "CFBundleVersion": "123"
        ]
        
        let version = mockBundle.appVersion
        // When version string is invalid, it falls back to null (0.0.0) but includes the build number
        XCTAssertEqual(version.major, 0)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.build, "123")
    }
    
    func testBundleWithMissingVersion() {
        let mockBundle = MockBundle()
        mockBundle.mockInfoDictionary = [:]
        
        let version = mockBundle.appVersion
        XCTAssertEqual(version, Version.null)
    }
    
    // MARK: - ProcessInfo OS Version Tests
    
    func testOSVersionExtraction() {
        let processInfo = ProcessInfo.processInfo
        let osVersion = processInfo.osVersion
        
        // OS version should always be valid and greater than 0
        XCTAssertGreaterThan(osVersion.major, 0)
        XCTAssertGreaterThanOrEqual(osVersion.minor, 0)
        XCTAssertGreaterThanOrEqual(osVersion.patch, 0)
        
        // Should not have label or build for OS versions
        XCTAssertNil(osVersion.label)
        XCTAssertNil(osVersion.build)
    }
    
    func testOSVersionFormat() {
        let processInfo = ProcessInfo.processInfo
        let osVersion = processInfo.osVersion
        
        // Verify the string format
        let description = osVersion.description
        let components = description.split(separator: ".").map(String.init)
        
        XCTAssertGreaterThanOrEqual(components.count, 2)
        XCTAssertLessThanOrEqual(components.count, 3)
        
        // All components should be numeric
        for component in components {
            XCTAssertNotNil(UInt(component), "OS version component should be numeric: \(component)")
        }
    }
}

// MARK: - Mock Bundle for Testing

private class MockBundle: Bundle, @unchecked Sendable {
    var mockInfoDictionary: [String: Any]?
    
    override var infoDictionary: [String: Any]? {
        return mockInfoDictionary
    }
}
