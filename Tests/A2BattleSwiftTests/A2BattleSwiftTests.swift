import XCTest
@testable import A2BattleSwift

class A2BattleSwiftTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(A2BattleSwift().text, "Hello, World!")
    }


    static var allTests : [(String, (A2BattleSwiftTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
