import Vapor
import Fluent


struct MyMigration: AsyncMigration {
    
    // Prepares the database for storing Template models.
    func prepare(on database: Database) async throws {
        try await database.schema("text_frames")
            .id()
            .field("template_id", .uuid)
            .field("x", .float)
            .field("y", .float)
            .field("width", .float)
            .create()
        
        try await database.schema("users")
            .field("uid", .int)
            .field("favorites", .array)
            .field("text_frames", .array)
            .create()
        
        try await database.schema("templates")
            .id()
            .field("owner_id", .int)
            .field("owner_name", .string)
            .field("created_at", .date)
            .create()
    }
    
    
    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await database.schema("text_frames").delete()
        try await database.schema("users").delete()
        try await database.schema("templates").delete()
    }
}
