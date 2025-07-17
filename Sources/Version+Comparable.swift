//
//  Version+Comparable.swift
//

import Foundation

extension Version: Comparable {
    public static func < (lhs: Version, rhs: Version) -> Bool {
        // Compare major.minor.patch first
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        if lhs.patch != rhs.patch { return lhs.patch < rhs.patch }
        
        // Handle pre-release versions according to SemVer rules
        // A pre-release version has lower precedence than normal version
        switch (lhs.label, rhs.label) {
        case (nil, nil):
            // Both are normal versions, compare build metadata
            return (lhs.build ?? "") < (rhs.build ?? "")
        case (nil, .some):
            // lhs is normal, rhs is pre-release -> lhs > rhs
            return false
        case (.some, nil):
            // lhs is pre-release, rhs is normal -> lhs < rhs
            return true
        case let (.some(lhsLabel), .some(rhsLabel)):
            // Both are pre-release, compare labels first
            if lhsLabel != rhsLabel {
                return lhsLabel < rhsLabel
            }
            // If labels are equal, compare build metadata
            return (lhs.build ?? "") < (rhs.build ?? "")
        }
    }
}
