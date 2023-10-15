@testable import SaferJSON
import XCTest

final class ArrayTests: XCTestCase {
    func testAppending() {
        var sut = SaferJSON(array: [])

        XCTAssertEqual(sut.appending(1.23), [1.23])
        XCTAssertEqual(sut.appending(true), [true])
        XCTAssertEqual(sut.appending(""), [""])
        XCTAssertEqual(sut.appending(SaferJSON()), [SaferJSON()])
        let null: Double? = nil
        XCTAssertEqual(sut.appending(null), [SaferJSON()])
        XCTAssertEqual(sut.appending(42), [42])
        XCTAssertEqual(sut.appending(contentsOf: [1, 2, 3]), [1, 2, 3])

        sut.append(1.23)
        XCTAssertEqual(sut, [1.23])
        sut.append(true)
        XCTAssertEqual(sut, [1.23, true])
        sut.append("")
        XCTAssertEqual(sut, [1.23, true, ""])
        sut.append(.init(object: ["a": 1]))
        XCTAssertEqual(sut, [1.23, true, "", ["a": 1]])
        sut.append(null)
        XCTAssertEqual(sut, [1.23, true, "", ["a": 1], SaferJSON()])
        sut.append(42)
        XCTAssertEqual(sut, [1.23, true, "", ["a": 1], Optional<Bool>.none, 42])
        sut.append(contentsOf: ["A", "B"])
        XCTAssertEqual(sut, [1.23, true, "", ["a": 1], Optional<Double>.none, 42, "A", "B"])
    }

    func testInserting() {
        var sut = SaferJSON(array: [23])

        XCTAssertEqual(sut.inserting(1.23, at: 0), [1.23, 23])
        XCTAssertEqual(sut.inserting(true, at: 0), [true, 23])
        XCTAssertEqual(sut.inserting("", at: 0), ["", 23])
        XCTAssertEqual(sut.inserting(SaferJSON(), at: 0), [SaferJSON(), 23])
        let null: Double? = nil
        XCTAssertEqual(sut.inserting(null, at: 0), [SaferJSON(), 23])
        XCTAssertEqual(sut.inserting(42, at: 0), [42, 23])
        XCTAssertEqual(sut.inserting(contentsOf: [1, 2, 3], at: 0), [1, 2, 3, 23])

        sut.insert(1.23, at: 0)
        XCTAssertEqual(sut, [1.23, 23])
        sut.insert(true, at: 0)
        XCTAssertEqual(sut, [true, 1.23, 23])
        sut.insert("", at: 0)
        XCTAssertEqual(sut, ["", true, 1.23, 23])
        sut.insert(.init(object: ["a": 1]), at: 0)
        XCTAssertEqual(sut, [["a": 1], "", true, 1.23, 23])
        sut.insert(null, at: 0)
        XCTAssertEqual(sut, [SaferJSON(), ["a": 1], "", true, 1.23, 23])
        sut.insert(42, at: 0)
        XCTAssertEqual(sut, [42, Optional<Double>.none, ["a": 1], "", true, 1.23, 23])
        sut.insert(contentsOf: ["A", "B"], at: 0)
        XCTAssertEqual(sut, ["A", "B", 42, Optional<Bool>.none, ["a": 1], "", true, 1.23, 23])
    }

    func testRemoving() {
        var sut = SaferJSON(array: [1, 2, 3])

        XCTAssertEqual(sut.removingValue(at: 1), [1, 3])
        XCTAssertEqual(sut.removingAll(), [])

        XCTAssertEqual(sut.removeValue(at: 1), 2)
        XCTAssertEqual(sut, [1, 3])
        sut.removeAll()
        XCTAssertEqual(sut, [])
    }
}
