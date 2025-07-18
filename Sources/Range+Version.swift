//
//  Range+Version.swift
//

import Foundation

extension ClosedRange where Bound == Version {
    public func contains(_ version: Version) -> Bool {
        return version >= lowerBound && version <= upperBound
    }
}

/// Convenience operator for version ranges in switch cases
public func ~= (range: ClosedRange<Version>, version: Version) -> Bool {
    return range.contains(version)
}

extension Range where Bound == Version {
    public func contains(_ version: Version) -> Bool {
        return version >= lowerBound && version < upperBound
    }
}

public func ~= (range: Range<Version>, version: Version) -> Bool {
    return range.contains(version)
}
