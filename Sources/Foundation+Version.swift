//
//  Foundation+Version.swift
//

import struct Foundation.OperatingSystemVersion
import class Foundation.ProcessInfo
import class Foundation.Bundle

/// An extension to Bundle that provides Versions
public extension Bundle {
    
    /// The version of the application bundle.
    @available(iOS 2.0, macOS 10.0, tvOS 9.0, watchOS 2.0, visionOS 1.0, *)
    var appVersion: Version {
        guard let version = infoDictionary?["CFBundleShortVersionString"]
            .flatMap({ $0 as? String })?
            .map(Version.init(stringLiteral:))
        else { return .null }
        
        let build = infoDictionary?["CFBundleVersion"]
            .flatMap({ $0 as? String })
        
        return Version(
            major: version.major,
            minor: version.minor,
            patch: version.patch,
            build: build
        )
    }
}

public extension ProcessInfo {
    /// The operating system version of the device.
    /// - Note: cannot call “super” from an extension that replaces that method
    /// tried to use keypaths but couldn’t. This way we are not making the
    /// method ambiguous anyway, so probably better.
    @available(iOS 8.0, macOS 10.0, tvOS 9.0, watchOS 2.0, visionOS 1.0, *)
    var osVersion: Version {
        // NOTE cannot call “super” from an extension that replaces that method
        // tried to use keypaths but couldn’t. This way we are not making the
        // method ambiguous anyway, so probably better.
        let v: OperatingSystemVersion = operatingSystemVersion
        return Version(
            major: UInt(v.majorVersion),
            minor: UInt(v.minorVersion),
            patch: UInt(v.patchVersion)
        )
    }
}
