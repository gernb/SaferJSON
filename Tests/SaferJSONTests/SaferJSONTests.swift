@testable import SaferJSON
import XCTest

final class SaferJSONTests: XCTestCase {
    var encoder: JSONEncoder!
    var decoder: JSONDecoder!

    override func setUp() {
        self.encoder = .init()
        self.encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.decoder = .init()
    }

    func testNull() throws {
        var sut = SaferJSON()

        XCTAssertEqual(sut.valueType, .null)
        XCTAssertTrue(sut.isEmpty)
        XCTAssertEqual(sut.count, -1)
        XCTAssertTrue(sut.isNull)
        XCTAssertNil(sut.get() as Double?)
        XCTAssertNil(sut.get() as Bool?)
        XCTAssertNil(sut.get() as String?)
        XCTAssertNil(sut[0] as SaferJSON?)
        XCTAssertNil(sut["key"] as SaferJSON?)
        sut = 42.0
        XCTAssertFalse(sut.isNull)
        sut.setNull()
        XCTAssertTrue(sut.isNull)
        try XCTAssertEqual(
            String(data: encoder.encode(sut), encoding: .utf8),
            "null"
        )
        sut = try decoder.decode(SaferJSON.self, from: "null".data(using: .utf8)!)
        XCTAssertEqual(sut, nil)

        sut = nil
        XCTAssertTrue(sut.isNull)
    }

    func testDouble() throws {
        var sut: SaferJSON = 42.0

        XCTAssertEqual(sut.valueType, .number)
        XCTAssertFalse(sut.isEmpty)
        XCTAssertEqual(sut.count, -1)
        XCTAssertFalse(sut.isNull)
        var value: Double? = sut.get()
        XCTAssertEqual(value, 42)
        XCTAssertNil(sut.get() as Bool?)
        XCTAssertNil(sut.get() as String?)
        XCTAssertNil(sut[0] as SaferJSON?)
        XCTAssertNil(sut["key"] as SaferJSON?)
        sut = false
        sut.set(value)
        XCTAssertEqual(sut.get() as Double?, 42)
        value = nil
        sut.set(value)
        XCTAssertTrue(sut.isNull)
        sut = 42.0
        try XCTAssertEqual(
            String(data: encoder.encode(sut), encoding: .utf8),
            "42"
        )
        sut = try decoder.decode(SaferJSON.self, from: "42".data(using: .utf8)!)
        XCTAssertEqual(sut.get() as Double?, Double(42))
    }

    func testBool() throws {
        var sut: SaferJSON = true

        XCTAssertEqual(sut.valueType, .bool)
        XCTAssertFalse(sut.isEmpty)
        XCTAssertEqual(sut.count, -1)
        XCTAssertFalse(sut.isNull)
        var value: Bool? = sut.get()
        XCTAssertEqual(value, true)
        XCTAssertNil(sut.get() as Double?)
        XCTAssertNil(sut.get() as String?)
        XCTAssertNil(sut[0] as SaferJSON?)
        XCTAssertNil(sut["key"] as SaferJSON?)
        sut = 42.0
        sut.set(value)
        XCTAssertEqual(sut.get() as Bool?, true)
        value = nil
        sut.set(value)
        XCTAssertTrue(sut.isNull)
        sut = false
        try XCTAssertEqual(
            String(data: encoder.encode(sut), encoding: .utf8),
            "false"
        )
        sut = try decoder.decode(SaferJSON.self, from: "true".data(using: .utf8)!)
        XCTAssertEqual(sut.get() as Bool?, true)
    }

    func testString() throws {
        var sut = SaferJSON(string: "Hello, world")

        XCTAssertEqual(sut.valueType, .string)
        XCTAssertFalse(sut.isEmpty)
        XCTAssertEqual(sut.count, "Hello, world".count)
        XCTAssertFalse(sut.isNull)
        var value: String? = sut.get()
        XCTAssertEqual(value, "Hello, world")
        XCTAssertNil(sut.get() as Double?)
        XCTAssertNil(sut.get() as Bool?)
        XCTAssertNil(sut[0] as SaferJSON?)
        XCTAssertNil(sut["key"] as SaferJSON?)
        sut = 42.0
        sut.set(value)
        XCTAssertEqual(sut.get() as String?, "Hello, world")
        value = nil
        sut.set(value)
        XCTAssertTrue(sut.isNull)
        sut = SaferJSON(string: "Hello, world")
        try XCTAssertEqual(
            String(data: encoder.encode(sut), encoding: .utf8),
            #""Hello, world""#
        )
        sut = try decoder.decode(SaferJSON.self, from: #""Hello, world""#.data(using: .utf8)!)
        XCTAssertEqual(sut.get() as String?, "Hello, world")
    }

    func testArray() throws {
        var sut = SaferJSON(array: [SaferJSON(number: 42)])

        XCTAssertEqual(sut.valueType, .array)
        XCTAssertFalse(sut.isEmpty)
        XCTAssertEqual(sut.count, 1)
        XCTAssertFalse(sut.isNull)
        XCTAssertEqual(sut.count, 1)
        var values: [SaferJSON]? = sut.get()
        XCTAssertEqual(values, [SaferJSON(number: 42)])
        XCTAssertNil(sut.get() as Double?)
        XCTAssertNil(sut.get() as Bool?)
        XCTAssertNil(sut.get() as String?)
        XCTAssertEqual(sut[0], 42.0)
        XCTAssertNil(sut["key"] as SaferJSON?)
        sut = 42.0
        sut.set(values)
        XCTAssertEqual(sut.get() as [SaferJSON]?, [SaferJSON(number: 42)])
        values = nil
        sut.set(values)
        XCTAssertTrue(sut.isNull)
        sut = SaferJSON(array: [SaferJSON(number: 42)])
        let json = """
            [
              42
            ]
            """
        try XCTAssertEqual(
            String(data: encoder.encode(sut), encoding: .utf8),
            json
        )
        sut = try decoder.decode(SaferJSON.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(sut.get() as [SaferJSON]?, [SaferJSON(number: 42)])

        let array: [Any]? = sut.array()
        XCTAssertEqual(array?.count, 1)

        sut = .init()
        sut[0] = 42
        XCTAssertEqual(sut, SaferJSON(array: [SaferJSON(number: 42)]))

        let numbers: [SaferJSON] = [0, 1, 2]
        sut.set(numbers)
        for (index, item) in sut.enumerated() {
            XCTAssertEqual(item.get(), index)
        }
    }

    func testObject() throws {
        var sut = SaferJSON(object: ["ultimate answer": SaferJSON(number: 42)])

        XCTAssertEqual(sut.valueType, .object)
        XCTAssertFalse(sut.isEmpty)
        XCTAssertEqual(sut.count, 1)
        XCTAssertFalse(sut.isNull)
        XCTAssertTrue(sut.exists("ultimate answer"))
        var object: [String: SaferJSON]? = sut.get()
        XCTAssertEqual(object, ["ultimate answer": SaferJSON(number: 42)])
        XCTAssertNil(sut.get() as Double?)
        XCTAssertNil(sut.get() as Bool?)
        XCTAssertNil(sut.get() as String?)
        XCTAssertNil(sut[0] as SaferJSON?)
        XCTAssertNil(sut["key"])
        XCTAssertEqual(sut["ultimate answer"], SaferJSON(number: 42))
        sut = 42.0
        sut.set(object)
        XCTAssertEqual(sut.get() as [String: SaferJSON]?, ["ultimate answer": SaferJSON(number: 42)])
        object = nil
        sut.set(object)
        XCTAssertTrue(sut.isNull)
        sut = SaferJSON(object: ["ultimate answer": SaferJSON(number: 42)])
        let json = """
            {
              "ultimate answer" : 42
            }
            """
        try XCTAssertEqual(
            String(data: encoder.encode(sut), encoding: .utf8),
            json
        )
        sut = try decoder.decode(SaferJSON.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(sut.get() as [String: SaferJSON]?, ["ultimate answer": SaferJSON(number: 42)])

        let dictionary: [String: Any]? = sut.dictionary()
        XCTAssertEqual(dictionary?["ultimate answer"] as? Double, 42)

        sut = .init()
        sut["key"] = SaferJSON(string: "value")
        XCTAssertEqual(sut, SaferJSON(object: ["key": SaferJSON(string: "value")]))

        XCTAssertFalse(sut.exists("not here"))
        XCTAssertEqual(sut.keys() as [String]?, ["key"])

        sut["key"] = nil
        XCTAssertFalse(sut.isEmpty)
        XCTAssertEqual(sut, SaferJSON(object: ["key": nil]))
        XCTAssertEqual(sut.removeValue(for: "key"), SaferJSON())
        XCTAssertTrue(sut.isEmpty)
    }

    func testMerging() {
        let sut = SaferJSON(object: ["a": 1, "b": 2])

        var result = sut.merging(SaferJSON(object: ["c": 3, "d": 4]))
        XCTAssertEqual(result, SaferJSON(object: ["a": 1, "b": 2, "c": 3, "d": 4]))

        result = sut.merging(SaferJSON(object: ["a": false, "e": 5]))
        XCTAssertEqual(result, SaferJSON(object: ["a": false, "b": 2, "e": 5]))
    }

    func testInt() throws {
        var sut: SaferJSON = 42

        XCTAssertEqual(sut.valueType, .number)
        XCTAssertFalse(sut.isEmpty)
        XCTAssertEqual(sut.count, -1)
        XCTAssertFalse(sut.isNull)
        var value: Int? = sut.get()
        XCTAssertEqual(value, 42)
        XCTAssertNil(sut.get() as Bool?)
        XCTAssertNil(sut.get() as String?)
        XCTAssertNil(sut[0] as SaferJSON?)
        XCTAssertNil(sut["key"] as SaferJSON?)
        sut = false
        sut.set(value)
        XCTAssertEqual(sut.get() as Int?, 42)
        value = nil
        sut.set(value)
        XCTAssertTrue(sut.isNull)
        sut = 42
        try XCTAssertEqual(
            String(data: encoder.encode(sut), encoding: .utf8),
            "42"
        )
        sut = try decoder.decode(SaferJSON.self, from: "42".data(using: .utf8)!)
        XCTAssertEqual(sut.get() as Int?, 42)
    }
}
