@testable import SaferJSON
import XCTest

final class DynamicMemberLookupTests: XCTestCase {
    func testHodgepodge() throws {
        let json: SaferJSON = """
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

        let one: Int = json.one
        XCTAssertEqual(one, 1)
        let two: String = json.two
        XCTAssertEqual(two, "two")
        let three_a: Double = json.three.a
        XCTAssertEqual(three_a, 1.1)
        let four: [Int] = json.four
        XCTAssertEqual(four, [0, 1, 2, 3])
        let four_3: Int = json.four[3]
        XCTAssertEqual(four_3, 3)
        let five: [Any] = json.five.array()
        XCTAssertEqual(five.count, 2)
        let five_0: SaferJSON = json.five[0]
        XCTAssertEqual(five_0.b, 2)
        let five_1_c: Int = json.five[1].c
        XCTAssertEqual(five_1_c, 3)
        let six: Bool = json.six
        XCTAssertEqual(six, false)
        let seven: Bool = json.seven
        XCTAssertEqual(seven, true)
        let keys: [String] = json["keys"]
        XCTAssertEqual(keys, ["C", "B", "A#"])

        XCTAssertEqual(json.three.a + 4, 5.1)

        struct Example: Codable, Equatable {
            let a: Double
            let b: Double
        }

        var example: Example = try! json.three.get()
        XCTAssertEqual(example, Example(a: 1.1, b: 2.2))
        let example2: Example = json.three
        XCTAssertEqual(example2, Example(a: 1.1, b: 2.2))

        // And now for something completely silly
        let unstructured: [String: any Codable] = [
            "a": Float(3.14),
            "b": Double(42),
        ]
        example = try! SaferJSON(dictionary: unstructured).get(as: Example.self)
        XCTAssertEqual(example, Example(a: 3.14, b: 42))

        // Going off the rails now...
        var kitchenSink = SaferJSON()
        kitchenSink.hammer = "uses nails"
        kitchenSink["answer to everything"] = 42
        kitchenSink.silly = true
        kitchenSink.example = Example(a: 1, b: 2)
        kitchenSink.one.two[0].three = 3
        try! kitchenSink.merge(example2)
        XCTAssertEqual(kitchenSink, """
        {
          "a" : 1.1,
          "answer to everything" : 42,
          "b" : 2.2,
          "example" : {
            "a" : 1,
            "b" : 2
          },
          "hammer" : "uses nails",
          "one" : {
            "two" : [
              {
                "three" : 3
              }
            ]
          },
          "silly" : true
        }
        """)

        struct NotCodable {
            var a: Int
        }
//        kitchenSink.dontDoThis = NotCodable(a: 23)

        let moreJson: SaferJSON = [
            "a": 1,
            "b": 2.3,
            "c": "see",
            "d": [true, false, true],
            "e": [
                "1": 1,
                "2": 2,
            ],
            "f": Example(a: 0, b: 0)
        ]
        let moreJson_f: Example = moreJson.f
        XCTAssertEqual(moreJson_f, Example(a: 0, b: 0))

        let heterogeneous: SaferJSON = """
        [
            1,
            "two",
            {"key": 3},
            [0, 1, 2],
        ]
        """
        XCTAssertEqual(heterogeneous.valueType, .array)
        XCTAssertEqual(heterogeneous[0].valueType, .number)
        XCTAssertEqual(heterogeneous[1].valueType, .string)
        XCTAssertEqual(heterogeneous[2].valueType, .object)
        XCTAssertEqual(heterogeneous[3].valueType, .array)
    }
}
