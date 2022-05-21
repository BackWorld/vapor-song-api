import Fluent
import Vapor

final class Song: Model, Content {
    static let schema = "songs"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: Fields.title)
    var title: String

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

func FK(_ string: String) -> FieldKey {
    .string(string)
}

extension Song {
    static let Fields = (
        id: FK("id"),
        title: FK("title"),
        coverUrl: FK("coverUrl")
    )
}
