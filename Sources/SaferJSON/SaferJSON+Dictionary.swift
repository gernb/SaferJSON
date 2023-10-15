public extension SaferJSON {
    subscript(key: String) -> SaferJSON? {
        get { storage.asObject?[key].map(Self.init(storage:)) }
        mutating set {
            let value = newValue?.storage ?? .null
            if var object = storage.asObject {
                object[key] = value
                storage = .object(object)
            } else {
                storage = .object([key: value])
            }
        }
    }
    subscript(key: String) -> SaferJSON {
        get { .init(storage: storage.asObject![key]!) }
        mutating set {
            let value = newValue.storage
            if var object = storage.asObject {
                object[key] = value
                storage = .object(object)
            } else {
                storage = .object([key: value])
            }
        }
    }

    @discardableResult
    mutating func removeValue(for key: String) -> SaferJSON? {
        guard var object = storage.asObject else { return nil }
        let result = object.removeValue(forKey: key).map(SaferJSON.init(storage:))
        storage = .object(object)
        return result
    }

    func exists(_ key: String) -> Bool {
        storage.asObject?.keys.contains(key) ?? false
    }

    func keys() -> [String]? {
        storage.asObject?.keys.map { $0 }
    }
    func keys() -> [String] {
        storage.asObject!.keys.map { $0 }
    }

    func dictionary() -> [String: Any]? {
        storage.asObject?.mapValues(\.value)
    }
    func dictionary() -> [String: Any] {
        storage.asObject!.mapValues(\.value)
    }

    static let defaultMergeStrategy: (Self, Self) -> Self = { $1 }

    func merging(_ other: Self, uniquingKeysWith: (Self, Self) -> Self = defaultMergeStrategy) -> Self? {
        guard let thisObject = storage.asObject else { return nil }
        guard let otherObject = other.storage.asObject else { return nil }
        let newObject = thisObject.merging(otherObject, uniquingKeysWith: {
            uniquingKeysWith(.init(storage: $0), .init(storage: $1)).storage
        })
        return .init(storage: .object(newObject))
    }

    mutating func merge(_ other: Self, uniquingKeysWith: (Self, Self) -> Self = defaultMergeStrategy) {
        self = merging(other, uniquingKeysWith: uniquingKeysWith) ?? self
    }
}
