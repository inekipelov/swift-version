//
//  Version+ExpressibleByStringLiteral.swift
//

import Foundation

extension Version: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        // For string literals, we want to be strict - if the string is invalid,
        // we should fail at compile time. However, since we can't fail at compile time,
        // we'll accept only simple valid strings and fallback to null for complex cases.
        
        // Try to parse strictly first
        if let version = try? Version.parse(from: value) {
            self = version
        } else {
            // For string literals, we provide a more lenient fallback
            // This allows basic usage like let version: Version = "1.0.0"
            // while still being safe for runtime parsing
            self = Version.null
        }
    }
}
