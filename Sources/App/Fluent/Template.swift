import Vapor
import Fluent


final class Template: Model, Content, @unchecked Sendable {
    
    // Name of the table or collection.
    static let schema = "templates"
    
    // Unique identifier for this Template.
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "owner_id")
    var owner_id: String

    @Field(key: "owner_name")
    var owner_name: String
    
    // Creates a new, empty Template.
    init() {}
    
    
    init(id: UUID? = nil, owner_id: String, owner_name: String) {
        self.id = id
        self.owner_id = owner_id
        self.owner_name = owner_name
    }
}



struct TemplateMigration: AsyncMigration {
    
    // Prepares the database for storing Galaxy models.
    func prepare(on database: Database) async throws {
        try await database.schema("templates")
            .id()
            .field("owner_id", .string)
            .field("owner_name", .string)
            .create()
    }
    
    
    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await database.schema("templates").delete()
    }
}
