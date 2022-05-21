import Fluent
import Vapor

struct SongController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let songs = routes.grouped("songs")
        songs.get(use: index)
        songs.post(use: create)
        songs.group(":songID") { song in
            song.delete(use: delete)
            song.put(use: update)
            song.patch(use: update)
        }
    }

    func index(req: Request) async throws -> [Song] {
        try await Song.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Song {
        let song = try req.content.decode(Song.self)
        try await song.save(on: req.db)
        return song
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let song = try await Song.find(req.parameters.get("songID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await song.delete(on: req.db)
        return .ok
    }
    
    func update(req: Request) async throws -> Song {
        guard
            let existSong = try await Song.find(req.parameters.get("songID"), on: req.db) else {
            throw Abort(.notFound)
        }
        guard let passSong = try? req.content.decode(Song.self) else {
            throw Abort(.notFound)
        }
        existSong.title = passSong.title
        try await existSong.save(on: req.db)
        return existSong
    }
}
