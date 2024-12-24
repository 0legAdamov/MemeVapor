import Vapor


func routes(_ app: Application) throws {
    
    app.get() { req in
        return "Hello!"
    }
    
    app.get("all") { req in
        return try await Template.query(on: req.db)
            .all()
    }
    
    /// Создание нового шаблона. Параметры:
    /// - `owner_id: String`
    /// - `owner_name: String`
    /// - В `body` передать изображение
    app.post("create") { req in
        let create = try req.query.decode(CreateRequest.self)
        
        guard let buffer = req.body.data else {
            throw CreateError.noBodyData
        }
        guard let data = buffer.getData(at: 0, length: buffer.readableBytes), data.count > 0 else {
            throw CreateError.emptyData
        }
        
        let id = UUID()
        
        let path = req.application.directory.publicDirectory + id.uuidString
        try await req.fileio.writeFile(ByteBuffer(data: data), at: path)
        
        let template = Template(id: id, owner_id: create.owner_id, owner_name: create.owner_name)
        try await template.create(on: req.db)
        
        return template
    }
}

//.. sync
