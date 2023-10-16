@dynamicMemberLookup
public struct SaferJSON {
    internal var storage: Primative

    public enum ValueType: String {
        case null, number, bool, string, array, object
    }
    public var valueType: ValueType { storage.type }

    public var isEmpty: Bool {
        switch storage {
        case .null: true
        case .number, .bool: false
        case .string(let value): value.isEmpty
        case .array(let values): values.isEmpty
        case .object(let object): object.isEmpty
        }
    }
    public var count: Int {
        switch storage {
        case .null: -1
        case .number, .bool: -1
        case .string(let value): value.count
        case .array(let values): values.count
        case .object(let object): object.count
        }
    }

    public init() {
        self.storage = .null
    }
    public init(number: Double?) {
        self.storage = number.map(Primative.number) ?? .null
    }
    public init(bool: Bool?) {
        self.storage = bool.map(Primative.bool) ?? .null
    }
    public init(string: String?) {
        self.storage = string.map(Primative.string) ?? .null
    }
    public init(array: [Self]?) {
        self.storage = array.map { .array($0.map(\.storage)) } ?? .null
    }
    public init(object: [String: Self]?) {
        self.storage = object.map { .object($0.mapValues(\.storage)) } ?? .null
    }

    public var isNull: Bool { storage == .null }
    public mutating func setNull() { storage = .null }

    public func get() -> Double? { storage.value as? Double }
    public mutating func set(_ value: Double?) {
        if let value { storage = .number(value) }
        else { storage = .null }
    }
    public func get() -> Double { storage.value as! Double }
    public mutating func set(_ value: Double) { storage = .number(value) }

    public func get() -> Bool? { storage.value as? Bool }
    public mutating func set(_ value: Bool?) {
        if let value { storage = .bool(value) }
        else { storage = .null }
    }
    public func get() -> Bool { storage.value as! Bool }
    public mutating func set(_ value: Bool) { storage = .bool(value) }

    public func get() -> String? { storage.value as? String }
    public mutating func set(_ value: String?) {
        if let value { storage = .string(value) }
        else { storage = .null }
    }
    public func get() -> String { storage.value as! String }
    public mutating func set(_ value: String) { storage = .string(value) }

    public func get() -> [Self]? { storage.asArray?.map(Self.init(storage:)) }
    public mutating func set(_ values: [Self]?) {
        if let values { storage = .array(values.map(\.storage)) }
        else { storage = .null }
    }
    public func get() -> [Self] { storage.asArray!.map(Self.init(storage:)) }
    public mutating func set(_ values: [Self]) { storage = .array(values.map(\.storage)) }

    public func get() -> [String: Self]? { storage.asObject?.mapValues(Self.init(storage:)) }
    public mutating func set(_ object: [String: Self]?) {
        if let object { storage = .object(object.mapValues(\.storage)) }
        else { storage = .null }
    }
    public func get() -> [String: Self] { storage.asObject!.mapValues(Self.init(storage:)) }
    public mutating func set(_ object: [String: Self]) { storage = .object(object.mapValues(\.storage)) }

    public func removingAll() -> Self {
        switch storage {
        case .null, .number, .bool, .string:
            return .init()
        case .array:
            return .init(array: [])
        case .object:
            return .init(object: [:])
        }
    }
    public mutating func removeAll() {
        self = self.removingAll()
    }
}

internal extension SaferJSON {
    init(storage: Primative) {
        self.storage = storage
    }
}

extension SaferJSON: Equatable {}
extension SaferJSON: Hashable {}
extension SaferJSON: Sendable {}
extension SaferJSON: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(storage)
    }
}
extension SaferJSON: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(storage: container.decode(Primative.self))
    }
}
extension SaferJSON: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init()
    }
}
extension SaferJSON: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(number: value)
    }
}
extension SaferJSON: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(bool: value)
    }
}
