enum Primative {
    case null
    case number(Double)
    case bool(Bool)
    case string(String)
    case array([Primative])
    case object([String: Primative])
}

extension Primative {
    var type: SaferJSON.ValueType {
        switch self {
        case .null: .null
        case .number: .number
        case .bool: .bool
        case .string: .string
        case .array: .array
        case .object: .object
        }
    }

    var value: Any {
        switch self {
        case .null: self
        case .number(let value): value
        case .bool(let value): value
        case .string(let value): value
        case .array(let values): values.map(\.value)
        case .object(let object): object.mapValues(\.value)
        }
    }

    var asArray: [Primative]? {
        if case .array(let value) = self {
            return value
        } else {
            return nil
        }
    }

    var asObject: [String: Primative]? {
        if case .object(let value) = self {
            return value
        } else {
            return nil
        }
    }
}

extension Primative: Equatable {}
extension Primative: Hashable {}
extension Primative: Sendable {}
extension Primative: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .null:
            try container.encodeNil()
        case .number(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .array(let values):
            try container.encode(values)
        case .object(let value):
            try container.encode(value)
        }
    }
}
extension Primative: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([Primative].self) {
            self = .array(value)
        } else if let value = try? container.decode([String: Primative].self) {
            self = .object(value)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unhandled value type.")
        }
    }
}
