import Vapor


enum CreateError: AbortError {
    
    case noBodyData
    case emptyData
    
    var reason: String {
        switch self {
            case .noBodyData: "No image data in body"
            case .emptyData: "Empty image data in body"
        }
    }
    
    var status: HTTPResponseStatus {
        switch self {
            case .noBodyData: .custom(code: 600, reasonPhrase: reason)
            case .emptyData: .custom(code: 601, reasonPhrase: reason)
        }
    }
}



struct CreateRequest: Content {
    let owner_id: Int
    let owner_name: String
}


struct AllRequest: Content {
    let uid: Int
}


struct TemplateResponse: Content {
    
    struct TextFrameResponse: Content {
        let x: Float
        let y: Float
        let width: Float
    }
    
    let id: UUID
    let owner_id: Int
    let owner_name: String
    let text_frames: [TextFrameResponse]
    
    init(template: Template, frames: [TextFrame]) {
        self.id = template.id!
        self.owner_id = template.ownerId
        self.owner_name = template.ownerName
        self.text_frames = frames
            .filter { $0.templateId == template.id }
            .map { TextFrameResponse(x: $0.x, y: $0.y, width: $0.width) }
    }
}


struct AllResponse: Content {
    let my: [TemplateResponse]
    let other: [TemplateResponse]
}
