import XCTest
@testable import NetworkingKit

class URLRequestTests: XCTestCase {
    private let path = "/path"

    override func setUp() {
        super.setUp()
    }

    func testMakePostRequest() throws {
        let urlRequest = try URLRequest.Builder(withBaseURL: "http://localhost")
            .path(path)
            .method(.post)
            .headers(["Content-Type": "application/json;charset=utf-8"])
            .build()
        XCTAssertEqual(urlRequest.httpMethod, "POST")
        XCTAssertEqual(urlRequest.url?.absoluteString, "http://localhost/path")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Content-Type"], "application/json;charset=utf-8")
    }
}
