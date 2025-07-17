//
//  Version+Equatable.swift
//

import Foundation

extension Version: Equatable {
    public static func == (lhs: Version, rhs: Version) -> Bool {
        return lhs.major == rhs.major &&
        lhs.minor == rhs.minor &&
        lhs.patch == rhs.patch &&
        lhs.label == rhs.label &&
        lhs.build == rhs.build
    }
}
