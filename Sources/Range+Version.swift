//
//  Range+Version.swift
//

extension ClosedRange where Bound == Version {
    public func contains(_ version: Version) -> Bool {
        return version >= lowerBound && version <= upperBound
    }
}

extension Range where Bound == Version {
    public func contains(_ version: Version) -> Bool {
        return version >= lowerBound && version < upperBound
    }
}
