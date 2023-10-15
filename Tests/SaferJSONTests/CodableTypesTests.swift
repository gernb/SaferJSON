@testable import SaferJSON
import XCTest

final class CodableTypesTests: XCTestCase {
    func testJSONStrings() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        let sut: SaferJSON = """
        {
          "one": 1,
          "two": "two",
          "three": {"a": 1.1, "b": 2.2},
          "four": [0, 1, 2, 3],
          "five": [
            {"a": 1, "b": 2},
            {"c": 3, "d": 4}
          ],
          "six": false,
          "seven": true,
          "keys": ["C", "B", "A#"],
        }
        """

        XCTAssertEqual(try sut.string(encoder: encoder) as String?, #"{"five":[{"a":1,"b":2},{"c":3,"d":4}],"four":[0,1,2,3],"keys":["C","B","A#"],"one":1,"seven":true,"six":false,"three":{"a":1.1,"b":2.2},"two":"two"}"#)
        XCTAssertEqual(sut.one, 1)
        XCTAssertEqual(sut.two, "two")
        XCTAssertEqual(sut.three, ["a": 1.1, "b": 2.2])
        XCTAssertEqual(sut.three.a, 1.1)
        XCTAssertEqual(sut.four, [0, 1, 2, 3])
        XCTAssertEqual(sut.four[2], 2)
        XCTAssertEqual(sut.five, [["a": 1, "b": 2], ["c": 3, "d": 4]])
        XCTAssertEqual(sut.five[1].c, 3)
        XCTAssertFalse(sut.six)
        XCTAssertTrue(sut.seven)
        XCTAssertEqual(sut["keys"], ["C", "B", "A#"])
        XCTAssertEqual(sut["keys"][1], "B")
    }

    func testCodableTypes() throws {
        var sut = try SaferJSON(Int8(42))
        XCTAssertEqual(sut, "42")

        struct Test: Codable {
            let a: Int
            let b: Bool
            let c: String
        }

        sut = try .init(Test(a: 1, b: true, c: "Hello, world"))
        XCTAssertEqual(sut, """
        {
          "a": 1,
          "b": true,
          "c": "Hello, world"
        }
        """)

        sut = try .init(Test(a: 1, b: true, c: "Hello, world"), forKey: "root")
        XCTAssertEqual(sut, """
        {
          "root" : {
            "a": 1,
            "b": true,
            "c": "Hello, world"
          }
        }
        """)

        sut = [1, 2, 3]
        XCTAssertEqual(sut, """
        [
          1,
          2,
          3
        ]
        """)

        sut = [
            "one": 1,
            "two": 2.2,
            "three": "3",
            "four": ["4", "four"],
            "five": Test(a: 5, b: false, c: "five")
        ]
        XCTAssertEqual(sut, """
        {
          "five" : {
              "a" : 5,
              "b" : false,
              "c" : "five"
            },
            "four" : [
              "4",
              "four"
            ],
            "one" : 1,
            "three" : "3",
            "two" : 2.2
        }
        """)
    }

    func testArrayMethods() throws {
        struct Test: Codable {
            let a: Int
        }

        var sut = SaferJSON(array: [1, 2, 3])
        try XCTAssertEqual(sut.appending(Test(a: 0)), [1, 2, 3, ["a": 0]])
        try XCTAssertEqual(sut.inserting(Test(a: 0), at: 0), [["a": 0], 1, 2, 3])

        try sut.append(Test(a: 4))
        XCTAssertEqual(sut, [1, 2, 3, ["a": 4]])
        try sut.insert(Test(a: 5), at: 0)
        XCTAssertEqual(sut, [["a": 5], 1, 2, 3, ["a": 4]])
    }
}
