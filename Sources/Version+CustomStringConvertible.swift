//
//  Version+CustomStringConvertible.swift
//

extension Version: CustomStringConvertible {
    public var description: String {
        // Always include major.minor.patch as per SemVer
        var base = "\(major).\(minor).\(patch)"
        
        if let label = label, !label.isEmpty {
            base += "-\(label)"
        }
        
        if let build = build, !build.isEmpty {
            base += "+\(build)"
        }
        
        return base
    }
}
