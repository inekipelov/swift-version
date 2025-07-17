//
//  StoreKit+Version.swift
//

#if canImport(StoreKit)
import StoreKit

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
extension AppTransaction {
    /// The version of the app that made the transaction.
    public var originalVersion: Version {
        return Version(stringLiteral: self.originalAppVersion)
    }
}

#endif
