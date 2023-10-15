import Foundation

public extension SaferJSON {
    static var encoder = JSONEncoder()
    static var decoder = JSONDecoder()

    init(data: Data, decoder: JSONDecoder = decoder) throws {
        try self.init(storage: decoder.decode(Primative.self, from: data))
    }
    init?(json: String, decoder: JSONDecoder = decoder) throws {
        guard let data = json.data(using: .utf8) else { return nil }
        try self.init(data: data, decoder: decoder)
    }
    init<T: Codable>(_ value: T, forKey key: String? = nil, encoder: JSONEncoder = encoder, decoder: JSONDecoder = decoder) throws {
        self.init()
        if let key {
            try self[key] = Self(value, encoder: encoder, decoder: decoder)
        } else {
            try set(value, encoder: encoder, decoder: decoder)
        }
    }

    init(values: [any Codable], encoder: JSONEncoder = encoder, decoder: JSONDecoder = decoder) throws {
        let array = try values.map {
            try decoder.decode(Primative.self, from: encoder.encode($0))
        }
        self.init(storage: .array(array))
    }
    init(values: any Codable..., encoder: JSONEncoder = encoder, decoder: JSONDecoder = decoder) throws {
        try self.init(values: values, encoder: encoder, decoder: decoder)
    }

    init(dictionary: [String: any Codable], encoder: JSONEncoder = encoder, decoder: JSONDecoder = decoder) throws {
        let object = try dictionary.mapValues {
            try decoder.decode(Primative.self, from: encoder.encode($0))
        }
        self.init(storage: .object(object))
    }
    init(elements: [(String, any Codable)], encoder: JSONEncoder = encoder, decoder: JSONDecoder = decoder) throws {
        try self.init(dictionary: .init(uniqueKeysWithValues: elements), encoder: encoder, decoder: decoder)
    }
    init(elements: (String, any Codable)..., encoder: JSONEncoder = encoder, decoder: JSONDecoder = decoder) throws {
        try self.init(elements: elements, encoder: encoder, decoder: decoder)
    }

    func data(encoder: JSONEncoder = encoder) throws -> Data {
        try encoder.encode(self)
    }
    func string(encoder: JSONEncoder = encoder) throws -> String? {
        try String(data: data(encoder: encoder), encoding: .utf8)
    }
    func string(encoder: JSONEncoder = encoder) -> String { try! string(encoder: encoder)! }

    func get<T: Codable>(encoder: JSONEncoder = encoder, decoder: JSONDecoder = decoder) throws -> T {
        try decoder.decode(T.self, from: data(encoder: encoder))
    }
    func get<T: Codable>(as type: T.Type, encoder: JSONEncoder = encoder, decoder: JSONDecoder = decoder) throws -> T {
        try get(encoder: encoder, decoder: decoder)
    }
    mutating func set<T: Codable>(_ value: T, encoder: JSONEncoder = encoder, decoder: JSONDecoder = decoder) throws {
        storage = try decoder.decode(Primative.self, from: encoder.encode(value))
    }

    subscript<T: Codable>(key: String) -> T {
        get { try! self[key]!.get() }
        mutating set { self[key] = try! Self(newValue) }
    }
    subscript<T: Codable>(dynamicMember member: String) -> T {
        get { self[member] }
        mutating set { self[member] = newValue }
    }

    func merging<T: Codable>(_ otherCodable: T, uniquingKeysWith: (Self, Self) -> Self = defaultMergeStrategy, encoder: JSONEncoder = encoder, decoder: JSONDecoder = decoder) throws -> Self? {
        guard let thisObject = storage.asObject else { return nil }
        guard let otherObject = try Self(otherCodable, encoder: encoder, decoder: decoder).storage.asObject else { return nil }
        let newObject = thisObject.merging(otherObject, uniquingKeysWith: {
            uniquingKeysWith(.init(storage: $0), .init(storage: $1)).storage
        })
        return .init(storage: .object(newObject))
    }
    mutating func merge<T: Codable>(_ otherCodable: T, uniquingKeysWith: (Self, Self) -> Self = defaultMergeStrategy, encoder: JSONEncoder = encoder, decoder: JSONDecoder = decoder) throws {
        self = try merging(otherCodable, uniquingKeysWith: uniquingKeysWith, encoder: encoder, decoder: decoder) ?? self
    }

    func appending<T: Codable>(_ value: T, encoder: JSONEncoder = encoder, decoder: JSONDecoder = decoder) throws -> Self? {
        guard valueType == .array else { return nil }
        return try self.appending(Self(value, encoder: encoder, decoder: decoder))
    }
    mutating func append<T: Codable>(_ value: T, encoder: JSONEncoder = encoder, decoder: JSONDecoder = decoder) throws {
        guard valueType == .array else { return }
        try self.append(Self(value, encoder: encoder, decoder: decoder))
    }

    func inserting<T: Codable>(_ value: T, at index: Int, encoder: JSONEncoder = encoder, decoder: JSONDecoder = decoder) throws -> Self? {
        guard valueType == .array else { return nil }
        return try self.inserting(Self(value, encoder: encoder, decoder: decoder), at: index)
    }
    mutating func insert<T: Codable>(_ value: T, at index: Int, encoder: JSONEncoder = encoder, decoder: JSONDecoder = decoder) throws {
        guard valueType == .array else { return }
        try self.insert(Self(value, encoder: encoder, decoder: decoder), at: index)
    }
}

extension SaferJSON: CustomStringConvertible {
    static let prettyPrintingEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }()

    public var description: String {
        string(encoder: Self.prettyPrintingEncoder)
    }
}
extension SaferJSON: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        try! self.init(json: value)!
    }
}
extension SaferJSON: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: any Codable...) {
        try! self.init(values: elements)
    }
}
extension SaferJSON: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, any Codable)...) {
        try! self.init(elements: elements)
    }
}
