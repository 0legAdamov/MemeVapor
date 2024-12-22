import Vapor


func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }
    
    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("info") { req in
        let remoteAddressStr = req.remoteAddress?.description ?? "No remote address info"
        let publicDir = req.application.directory.publicDirectory
        let fileManager = FileManager.default.currentDirectoryPath
        return remoteAddressStr + "\n" + publicDir + "\n" + fileManager
    }
    
    app.post("create") { req in
        let create = try req.query.decode(CreateRequest.self)
        
        guard let buffer = req.body.data else {
            throw CreateError.noBodyData
        }
        guard let data = buffer.getData(at: 0, length: buffer.readableBytes), data.count > 0 else {
            throw CreateError.emptyData
        }
        
        let id = UUID()
        
        let template = Template(id: id, owner_id: create.owner_id, owner_name: create.owner_name)
        try await template.create(on: req.db)
        
        let path = req.application.directory.publicDirectory + id.uuidString
        try await req.fileio.writeFile(ByteBuffer(data: data), at: path)
        
        return template
    }
}
