public extension SaferJSON {
    subscript(dynamicMember member: String) -> Double? {
        get { self[member]?.get() }
        mutating set { self[member] = newValue.map { Self(storage: .number($0)) } }
    }
    subscript(dynamicMember member: String) -> Double {
        get { self[member]!.get() }
        mutating set { self[member] = Self(storage: .number(newValue)) }
    }

    subscript(dynamicMember member: String) -> Bool? {
        get { self[member]?.get() }
        mutating set { self[member] = newValue.map { Self(storage: .bool($0)) } }
    }
    subscript(dynamicMember member: String) -> Bool {
        get { self[member]!.get() }
        mutating set { self[member] = Self(storage: .bool(newValue)) }
    }

    subscript(dynamicMember member: String) -> String? {
        get { self[member]?.get() }
        mutating set { self[member] = newValue.map { Self(storage: .string($0)) } }
    }
    subscript(dynamicMember member: String) -> String {
        get { self[member]!.get() }
        mutating set { self[member] = Self(storage: .string(newValue)) }
    }

    subscript(dynamicMember member: String) -> SaferJSON? {
        get { self[member] }
        mutating set { self[member] = newValue }
    }
    subscript(dynamicMember member: String) -> SaferJSON {
        get { self[member] ?? .init() }
        mutating set { self[member] = newValue }
    }
}
