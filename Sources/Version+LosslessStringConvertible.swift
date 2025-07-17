//
//  Version+LosslessStringConvertible.swift
//

extension Version: LosslessStringConvertible {
    public init?(_ description: String) {
        // Use the unified parsing method with fallback to nil
        guard let version = try? Version.parse(from: description) else {
            return nil
        }
        self = version
    }
}
