public extension SaferJSON {
    subscript(index: Int) -> Double? {
        get { self[index]?.get() }
        mutating set { self[index] = .init(number: newValue) }
    }
    subscript(index: Int) -> Double {
        get { self[index].get() }
        mutating set { self[index] = .init(number: newValue) }
    }

    subscript(index: Int) -> Bool? {
        get { self[index]?.get() }
        mutating set { self[index] = .init(bool: newValue) }
    }
    subscript(index: Int) -> Bool {
        get { self[index].get() }
        mutating set { self[index] = .init(bool: newValue) }
    }

    subscript(index: Int) -> String? {
        get { self[index]?.get() }
        mutating set { self[index] = .init(string: newValue) }
    }
    subscript(index: Int) -> String {
        get { self[index].get() }
        mutating set { self[index] = .init(string: newValue) }
    }

    subscript(index: Int) -> Self? {
        get { (storage.asArray?[index]).map(Self.init(storage:)) }
        mutating set {
            let value = newValue?.storage ?? .null
            if var values = storage.asArray {
                values[index] = value
                storage = .array(values)
            } else {
                var values: [Primative] = [.null]
                values[index] = value
                storage = .array(values)
            }
        }
    }
    subscript(index: Int) -> Self {
        get { .init(storage: storage.asArray?[index] ?? .array([.null])) }
        mutating set {
            let value = newValue.storage
            if var values = storage.asArray {
                values[index] = value
                storage = .array(values)
            } else {
                var values: [Primative] = [.null]
                values[index] = value
                storage = .array(values)
            }
        }
    }

    func array() -> [Any]? {
        storage.asArray?.map(\.value)
    }
    func array() -> [Any] {
        storage.asArray!.map(\.value)
    }

    func appending(_ value: Double?) -> Self? {
        guard var values = storage.asArray else { return nil }
        values.append(value.map(Primative.number) ?? .null)
        return .init(storage: .array(values))
    }
    func appending(_ value: Double) -> Self? {
        guard var values = storage.asArray else { return nil }
        values.append(.number(value))
        return .init(storage: .array(values))
    }
    func appending(_ value: Bool?) -> Self? {
        guard var values = storage.asArray else { return nil }
        values.append(value.map(Primative.bool) ?? .null)
        return .init(storage: .array(values))
    }
    func appending(_ value: Bool) -> Self? {
        guard var values = storage.asArray else { return nil }
        values.append(.bool(value))
        return .init(storage: .array(values))
    }
    func appending(_ value: String?) -> Self? {
        guard var values = storage.asArray else { return nil }
        values.append(value.map(Primative.string) ?? .null)
        return .init(storage: .array(values))
    }
    func appending(_ value: String) -> Self? {
        guard var values = storage.asArray else { return nil }
        values.append(.string(value))
        return .init(storage: .array(values))
    }
    func appending(_ value: Self?) -> Self? {
        guard var values = storage.asArray else { return nil }
        values.append(value.map(\.storage) ?? .null)
        return .init(storage: .array(values))
    }
    func appending(_ value: Self) -> Self? {
        guard var values = storage.asArray else { return nil }
        values.append(value.storage)
        return .init(storage: .array(values))
    }
    func appending(contentsOf value: Self) -> Self? {
        guard var values = storage.asArray else { return nil }
        switch value.storage {
        case .null, .number, .bool, .string, .object:
            values.append(value.storage)
        case .array(let other):
            values.append(contentsOf: other)
        }
        return .init(storage: .array(values))
    }

    mutating func append(_ value: Double?) {
        self = self.appending(value) ?? self
    }
    mutating func append(_ value: Double) {
        self = self.appending(value) ?? self
    }
    mutating func append(_ value: Bool?) {
        self = self.appending(value) ?? self
    }
    mutating func append(_ value: Bool) {
        self = self.appending(value) ?? self
    }
    mutating func append(_ value: String?) {
        self = self.appending(value) ?? self
    }
    mutating func append(_ value: String) {
        self = self.appending(value) ?? self
    }
    mutating func append(_ value: Self?) {
        self = self.appending(value) ?? self
    }
    mutating func append(_ value: Self) {
        self = self.appending(value) ?? self
    }
    mutating func append(contentsOf value: Self) {
        self = self.appending(contentsOf: value) ?? self
    }

    func inserting(_ value: Double?, at index: Int) -> Self? {
        guard var values = storage.asArray else { return nil }
        values.insert(value.map(Primative.number) ?? .null, at: index)
        return .init(storage: .array(values))
    }
    func inserting(_ value: Double, at index: Int) -> Self? {
        guard var values = storage.asArray else { return nil }
        values.insert(.number(value), at: index)
        return .init(storage: .array(values))
    }
    func inserting(_ value: Bool?, at index: Int) -> Self? {
        guard var values = storage.asArray else { return nil }
        values.insert(value.map(Primative.bool) ?? .null, at: index)
        return .init(storage: .array(values))
    }
    func inserting(_ value: Bool, at index: Int) -> Self? {
        guard var values = storage.asArray else { return nil }
        values.insert(.bool(value), at: index)
        return .init(storage: .array(values))
    }
    func inserting(_ value: String?, at index: Int) -> Self? {
        guard var values = storage.asArray else { return nil }
        values.insert(value.map(Primative.string) ?? .null, at: index)
        return .init(storage: .array(values))
    }
    func inserting(_ value: String, at index: Int) -> Self? {
        guard var values = storage.asArray else { return nil }
        values.insert(.string(value), at: index)
        return .init(storage: .array(values))
    }
    func inserting(_ value: Self?, at index: Int) -> Self? {
        guard var values = storage.asArray else { return nil }
        values.insert(value.map(\.storage) ?? .null, at: index)
        return .init(storage: .array(values))
    }
    func inserting(_ value: Self, at index: Int) -> Self? {
        guard var values = storage.asArray else { return nil }
        values.insert(value.storage, at: index)
        return .init(storage: .array(values))
    }
    func inserting(contentsOf value: Self, at index: Int) -> Self? {
        guard var values = storage.asArray else { return nil }
        switch value.storage {
        case .null, .number, .bool, .string, .object:
            values.insert(value.storage, at: index)
        case .array(let other):
            values.insert(contentsOf: other, at: index)
        }
        return .init(storage: .array(values))
    }

    mutating func insert(_ value: Double?, at index: Int) {
        self = self.inserting(value, at: index) ?? self
    }
    mutating func insert(_ value: Double, at index: Int) {
        self = self.inserting(value, at: index) ?? self
    }
    mutating func insert(_ value: Bool?, at index: Int) {
        self = self.inserting(value, at: index) ?? self
    }
    mutating func insert(_ value: Bool, at index: Int) {
        self = self.inserting(value, at: index) ?? self
    }
    mutating func insert(_ value: String?, at index: Int) {
        self = self.inserting(value, at: index) ?? self
    }
    mutating func insert(_ value: String, at index: Int) {
        self = self.inserting(value, at: index) ?? self
    }
    mutating func insert(_ value: Self?, at index: Int) {
        self = self.inserting(value, at: index) ?? self
    }
    mutating func insert(_ value: Self, at index: Int) {
        self = self.inserting(value, at: index) ?? self
    }
    mutating func insert(contentsOf value: Self, at index: Int) {
        self = self.inserting(contentsOf: value, at: index) ?? self
    }

    func removingValue(at index: Int) -> Self? {
        guard var values = storage.asArray else { return nil }
        values.remove(at: index)
        return .init(storage: .array(values))
    }
    mutating func removeValue(at index: Int) -> Self? {
        guard var values = storage.asArray else { return nil }
        let result = values.remove(at: index)
        storage = .array(values)
        return .init(storage: result)
    }
}

extension SaferJSON: Sequence {
    public func makeIterator() -> [SaferJSON].Iterator {
        (get() ?? []).makeIterator()
    }
}
