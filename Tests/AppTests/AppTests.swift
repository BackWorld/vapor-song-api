@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    let app = Application(.testing)
    let headers: HTTPHeaders = [
        "Content-Type": "application/json"
    ]
    
    override func setUpWithError() throws {
        try configure(app)
    }
    
    override func tearDownWithError() throws {
        app.shutdown()
    }
    
    func testHelloWorld() throws {
        try app.test(.GET, "hello", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Hello, world!")
        })
    }
    
    func testCreateSong() throws {
        let song = Song(title: "Test Song")
        try app.test(.POST, "songs", headers: headers, body: JSONEncoder().encodeAsByteBuffer(song, allocator: .init()), afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let savedSong = try JSONDecoder().decode(Song.self, from: res.body)
            XCTAssertEqual(song.title, savedSong.title)
        })
    }
    
    func testDeleteNotFoundSong() throws {
        let songID = "318ec28a-5aa0-4ea3-afdb-572b5f105497"
        try app.test(.DELETE, "songs/\(songID)", afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
        })
    }
    
    func testDeleteExistedSong() throws {
        let songID = "318ec28a-5aa0-4ea3-afdb-572b5f105497"
        try app.test(.DELETE, "songs/\(songID)", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }
    
    func testUpdateSong() throws {
        let songID = "bd2abb1b-50e9-4a5a-9b3d-2f0af940a5ad"
        let song = Song(title: "New Song Name")
        try app.test(
            .PUT,
            "songs/\(songID)",
            headers: headers,
            body: JSONEncoder().encodeAsByteBuffer(song, allocator: .init()),
            afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
                
            let savedSong = try JSONDecoder().decode(Song.self, from: res.body)
                XCTAssertEqual(songID, savedSong.id?.uuidString.lowercased())
            XCTAssertEqual(song.title, savedSong.title)
        })
    }
    
    func testPatchUpdateSong() throws {
        let songID = "bd2abb1b-50e9-4a5a-9b3d-2f0af940a5ad"
        let song = Song(title: "Patch Udpated Song Name")
        try app.test(
            .PATCH,
            "songs/\(songID)",
            headers: headers,
            body: JSONEncoder().encodeAsByteBuffer(song, allocator: .init()),
            afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
                
            let savedSong = try JSONDecoder().decode(Song.self, from: res.body)
                XCTAssertEqual(songID, savedSong.id?.uuidString.lowercased())
                print(savedSong)
            XCTAssertEqual(song.title, savedSong.title)
        })
    }
}
