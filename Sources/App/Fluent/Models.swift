import Vapor
import Fluent


// MARK: - TextFrame
final class TextFrame: Model, @unchecked Sendable {
    
    static let schema = "text_frames"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "template_id")
    var templateId: UUID
    
    @Field(key: "x")
    var x: Float
    
    @Field(key: "y")
    var y: Float
    
    @Field(key: "width")
    var width: Float
    
    init() {}
    
    init(template: UUID, x: Float, y: Float, width: Float) {
        self.templateId = template
        self.x = x
        self.y = y
        self.width = width
    }
}



// MARK: - User
final class User: Model, Content, @unchecked Sendable {
    
    static let schema = "users"
    
    @ID(custom: "uid", generatedBy: .user)
    var id: Int?
    
    @Field(key: "favorites")
    var favorites: [UUID]
    
    @Field(key: "text_frames")
    var textFrames: [TextFrame]
    
    init() {}
    
    init(id: Int) {
        self.id = id
        self.favorites = []
        self.textFrames = []
    }
}



// MARK: - Template
final class Template: Model, Content, @unchecked Sendable {
    
    static let schema = "templates"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "owner_id")
    var ownerId: Int

    @Field(key: "owner_name")
    var ownerName: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, ownerId: Int, ownerName: String) {
        self.id = id
        self.ownerId = ownerId
        self.ownerName = ownerName
        self.createdAt = nil
    }
}
