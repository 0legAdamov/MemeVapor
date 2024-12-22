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



struct CreateResponse: Content {
    
    let template_id: String
    let owner_id: String
    let owner_name: String
}



struct CreateRequest: Content {
    
    let owner_id: String
    let owner_name: String
}
