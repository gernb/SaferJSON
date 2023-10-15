@testable import SaferJSON
import XCTest

final class PrimativeTests: XCTestCase {
    var encoder: JSONEncoder!
    var decoder: JSONDecoder!

    override func setUp() {
        self.encoder = .init()
        self.encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.decoder = .init()
    }

    func testNull() throws {
        var sut = Primative.null

        XCTAssertEqual(sut.type, .null)
        XCTAssertNil(sut.value as? Double)
        XCTAssertNil(sut.value as? Bool)
        XCTAssertNil(sut.value as? String)
        XCTAssertNil(sut.asArray)
        XCTAssertNil(sut.asObject)
        try XCTAssertEqual(
            String(data: encoder.encode(sut), encoding: .utf8),
            "null"
        )
        sut = try decoder.decode(Primative.self, from: "null".data(using: .utf8)!)
        XCTAssertEqual(sut, .null)
    }

    func testNumber() throws {
        var sut = Primative.number(42)

        XCTAssertEqual(sut.type, .number)
        XCTAssertEqual(sut.value as? Double, 42)
        XCTAssertNil(sut.asArray)
        XCTAssertNil(sut.asObject)
        try XCTAssertEqual(
            String(data: encoder.encode(sut), encoding: .utf8),
            "42"
        )
        sut = try decoder.decode(Primative.self, from: "42".data(using: .utf8)!)
        XCTAssertEqual(sut, .number(42))

        sut = Primative.number(3.14)

        XCTAssertEqual(sut.type, .number)
        XCTAssertEqual(sut.value as? Double, 3.14)
        XCTAssertNil(sut.asArray)
        XCTAssertNil(sut.asObject)
        try XCTAssertEqual(
            String(data: encoder.encode(sut), encoding: .utf8),
            "3.14"
        )
        sut = try decoder.decode(Primative.self, from: "3.14".data(using: .utf8)!)
        XCTAssertEqual(sut, .number(3.14))
    }

    func testBool() throws {
        var sut = Primative.bool(true)

        XCTAssertEqual(sut.type, .bool)
        XCTAssertEqual(sut.value as? Bool, true)
        XCTAssertNil(sut.asArray)
        XCTAssertNil(sut.asObject)
        try XCTAssertEqual(
            String(data: encoder.encode(sut), encoding: .utf8),
            "true"
        )
        sut = try decoder.decode(Primative.self, from: "true".data(using: .utf8)!)
        XCTAssertEqual(sut, .bool(true))

        sut = Primative.bool(false)

        XCTAssertEqual(sut.type, .bool)
        XCTAssertEqual(sut.value as? Bool, false)
        XCTAssertNil(sut.asArray)
        XCTAssertNil(sut.asObject)
        try XCTAssertEqual(
            String(data: encoder.encode(sut), encoding: .utf8),
            "false"
        )
        sut = try decoder.decode(Primative.self, from: "false".data(using: .utf8)!)
        XCTAssertEqual(sut, .bool(false))
    }

    func testString() throws {
        var sut = Primative.string("")

        XCTAssertEqual(sut.type, .string)
        XCTAssertEqual(sut.value as? String, "")
        XCTAssertNil(sut.asArray)
        XCTAssertNil(sut.asObject)
        try XCTAssertEqual(
            String(data: encoder.encode(sut), encoding: .utf8),
            #""""#
        )
        sut = try decoder.decode(Primative.self, from: #""""#.data(using: .utf8)!)
        XCTAssertEqual(sut, .string(""))

        sut = Primative.string("Hello, world")

        XCTAssertEqual(sut.type, .string)
        XCTAssertEqual(sut.value as? String, "Hello, world")
        XCTAssertNil(sut.asArray)
        XCTAssertNil(sut.asObject)
        try XCTAssertEqual(
            String(data: encoder.encode(sut), encoding: .utf8),
            #""Hello, world""#
        )
        sut = try decoder.decode(Primative.self, from: #""Hello, world""#.data(using: .utf8)!)
        XCTAssertEqual(sut, .string("Hello, world"))
    }

    func testArray() throws {
        let json = """
        [
          null,
          1,
          3.14,
          true,
          "String",
          [
            0,
            {
              "one" : 1
            }
          ]
        ]
        """
        var sut = Primative.array([
            .null, .number(1), .number(3.14), .bool(true), .string("String"),
            .array([.number(0), .object(["one": .number(1)]),]),
        ])

        XCTAssertEqual(sut.type, .array)
        XCTAssertEqual((sut.value as? [Any])?.count, 6)
        XCTAssertEqual(sut.asArray, [
            .null, .number(1), .number(3.14), .bool(true), .string("String"),
            .array([.number(0), .object(["one": .number(1)]),]),
        ])
        XCTAssertNil(sut.asObject)
        try XCTAssertEqual(
            String(data: encoder.encode(sut), encoding: .utf8),
            json
        )
        sut = try decoder.decode(Primative.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(sut, .array([
            .null, .number(1), .number(3.14), .bool(true), .string("String"),
            .array([.number(0), .object(["one": .number(1)]),]),
        ]))
    }


    func testObject() throws {
        let json = """
        {
          "array" : [
            null
          ],
          "null" : null,
          "one" : 1,
          "three" : {

          },
          "two" : "two"
        }
        """
        var sut = Primative.object([
            "one": .number(1),
            "null": .null,
            "two": .string("two"),
            "array": .array([.null]),
            "three": .object([:]),
        ])
        XCTAssertEqual(sut.type, .object)
        XCTAssertEqual((sut.value as? [String: Any])?.count, 5)
        XCTAssertNil(sut.asArray)
        XCTAssertEqual(sut.asObject, [
            "one": .number(1),
            "null": .null,
            "two": .string("two"),
            "array": .array([.null]),
            "three": .object([:]),
        ])
        try XCTAssertEqual(
            String(data: encoder.encode(sut), encoding: .utf8),
            json
        )
        sut = try decoder.decode(Primative.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(sut, .object([
            "one": .number(1),
            "null": .null,
            "two": .string("two"),
            "array": .array([.null]),
            "three": .object([:]),
        ]))
    }
}
