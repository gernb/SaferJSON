public extension SaferJSON {
    init(number: Int?) {
        self.storage = number.map { .number(Double($0)) } ?? .null
    }

    func get() -> Int? { (storage.value as? Double).map(Int.init) }
    mutating func set(_ value: Int?) {
        if let value { storage = .number(Double(value)) }
        else { storage = .null }
    }
    func get() -> Int { Int(storage.value as! Double) }
    mutating func set(_ value: Int) { storage = .number(Double(value)) }

    subscript(index: Int) -> Int? {
        get { self[index]?.get() }
        mutating set { self[index] = .init(number: newValue) }
    }
    subscript(index: Int) -> Int {
        get { self[index].get() }
        mutating set { self[index] = .init(number: newValue) }
    }

    subscript(dynamicMember member: String) -> Int? {
        get { self[member]?.get() }
        mutating set { self[member] = .init(number: newValue) }
    }
    subscript(dynamicMember member: String) -> Int {
        get { self[member]!.get() }
        mutating set { self[member] = .init(number: newValue) }
    }

    func appending(_ value: Int?) -> Self? {
        return self.appending(value.map(Double.init))
    }
    func appending(_ value: Int) -> Self? {
        return self.appending(Double(value))
    }
    mutating func append(_ value: Int?) {
        self = self.appending(value) ?? self
    }
    mutating func append(_ value: Int) {
        self = self.appending(value) ?? self
    }

    func inserting(_ value: Int?, at index: Int) -> Self? {
        return self.inserting(value.map(Double.init), at: index)
    }
    func inserting(_ value: Int, at index: Int) -> Self? {
        return self.inserting(Double(value), at: index)
    }
    mutating func insert(_ value: Int?, at index: Int) {
        self = self.inserting(value, at: index) ?? self
    }
    mutating func insert(_ value: Int, at index: Int) {
        self = self.inserting(value, at: index) ?? self
    }
}

extension SaferJSON: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(number: value)
    }
}
