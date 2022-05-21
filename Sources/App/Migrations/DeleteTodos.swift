//
//  File.swift
//  
//
//  Created by zhuxuhong on 2022/5/21.
//

import FluentKit

struct DeleteTodos: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("todos").delete()
    }
    
    func revert(on database: Database) async throws {
    }
}
