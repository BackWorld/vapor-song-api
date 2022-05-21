import Fluent

extension Song {
    struct Migrations {
        static let configured: [Migration] = [
            Create()
        ]
    }
}

fileprivate let Fields = Song.Fields

extension Song.Migrations {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(Song.schema)
                .id()
                .field(Fields.title, .string, .required)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Song.schema).delete()
        }
    }
}
